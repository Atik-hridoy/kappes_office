import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
import 'package:canuck_mall/app/data/netwok/message/get_message_service.dart';
import 'package:canuck_mall/app/model/message_and_chat/create_chat_model.dart' as create_chat;
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart' as get_chat;
import 'package:canuck_mall/app/model/message_and_chat/get_message.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/utils/log/error_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChattingViewController extends GetxController {
  final messageTextEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  RxBool isBoxOpen = false.obs;
  RxList<Message> messages = <Message>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxInt currentPage = 1.obs;

  static const int messagesPerPage = 20;
  late final CreateChatToSellerService chatService;
  late final GetMessageService messageService;
  
  String chatId = '';
  String? shopId;
  String? shopName;

  String get currentUserId => LocalStorage.userId;

  // Constructor to initialize services
  ChattingViewController({required this.chatService, required this.messageService});

  @override
  void onInit() {
    super.onInit();
    _initializeChatData();
    _setupScrollListener();
    _setUIOverlayStyle();

    // Fetch initial messages or create a new chat
    if (chatId.isNotEmpty) {
      fetchMessages(isRefresh: true);
    } else if (shopId?.isNotEmpty ?? false) {
      createChat();
    } else {
      AppUtils.showError('Unable to start chat: Missing shop information');
    }
  }

  // Initialize chatId, shopId, and shopName based on passed arguments
  void _initializeChatData() {
    _applyArguments(Get.arguments);
  }

  void syncWithArguments(dynamic args) {
    final changed = _applyArguments(args);
    if (!changed) return;

    if (chatId.isNotEmpty) {
      fetchMessages(isRefresh: true);
    } else if (shopId?.isNotEmpty ?? false) {
      createChat();
    }
  }

  bool _applyArguments(dynamic args) {
    if (args == null) return false;

    final prevChatId = chatId;
    final prevShopId = shopId;
    final prevShopName = shopName;

    if (args is Map<String, dynamic>) {
      chatId = args['chatId']?.toString() ?? '';
      shopId = args['shopId']?.toString();
      shopName = args['shopName']?.toString();
    } else if (args is get_chat.Chat) {
      final chat = args;
      chatId = chat.id;
      final shopParticipant = chat.participants.firstWhereOrNull(
        (p) => p.participantType.toString().toLowerCase() == 'shop'
      );
      if (shopParticipant != null) {
        shopId = shopParticipant.id;
        // Handle both Shop and User types
        if (shopParticipant.participantId is get_chat.Shop) {
          shopName = (shopParticipant.participantId as get_chat.Shop).name;
        } else if (shopParticipant.participantId is get_chat.User) {
          shopName = (shopParticipant.participantId as get_chat.User).fullName;
        } else {
          shopName = 'Shop';
        }
      }
    } else {
      return false;
    }

    return chatId != prevChatId || shopId != prevShopId || shopName != prevShopName;
  }

  // Setup scroll listener for infinite scroll
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value && hasMore.value) {
        fetchMessages();
      }
    });
  }

  // Set UI overlay for status bar
  void _setUIOverlayStyle() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
      ));
    });
  }

  // Create chat between user and shop
  Future<void> createChat() async {
    if (shopId == null || shopId!.isEmpty) {
      AppUtils.showError('Shop ID is required to create a chat');
      return;
    }

    try {
      final userId = LocalStorage.userId;
      final userFullName = LocalStorage.myName.isNotEmpty ? LocalStorage.myName : 'User';
      final userEmail = LocalStorage.myEmail;
      final userPhone = LocalStorage.phone;

      final chatData = create_chat.ChatData(
        id: '',
        participants: [
          create_chat.Participant(
            id: userId,
            participantId: create_chat.ParticipantId(
              id: userId,
              fullName: userFullName,
              role: 'USER',
              email: userEmail,
              phone: userPhone,
              verified: true,
              isDeleted: false,
            ),
            participantType: 'User',
          ),
          create_chat.Participant(
            id: shopId!,
            participantId: create_chat.ParticipantId(
              id: shopId!,
              fullName: shopName ?? 'Shop',
              role: 'Shop',
              email: '',
              phone: '',
              verified: true,
              isDeleted: false,
            ),
            participantType: 'Shop',
          ),
        ],
        status: true,
      );

      final chatResponse = await chatService.createChat(chatData);

      if (chatResponse.success) {
        chatId = chatResponse.data.id;
        AppUtils.showSuccess("Chat created successfully!");
        fetchMessages();
      } else {
        AppUtils.showError("Failed to create chat: ${chatResponse.message}");
      }
    } catch (e) {
      AppUtils.showError("Error creating chat: $e");
    }
  }

  // Fetch messages with pagination
  Future<void> fetchMessages({bool isRefresh = false}) async {
    if (isLoading.value) return;

    try {
      if (chatId.isEmpty) {
        AppLogger.error('Cannot fetch messages: chatId is empty', tag: 'CHAT_FETCH', error: 'chatId is empty');
        AppUtils.showError('Chat reference missing. Please reopen the chat.');
        return;
      }

      if (isRefresh) {
        currentPage.value = 1;
        hasMore.value = true;
        messages.clear();
      }

      if (!hasMore.value) return;

      isLoading.value = true;
      final response = await messageService.fetchMessages(
        chatId, currentPage.value, messagesPerPage
      );

      if (response != null && response.success) {
        AppLogger.info(
          'Fetched ${response.data.messages.length} messages (page ${currentPage.value})',
          tag: 'CHAT_FETCH',
          context: {
            'chatId': chatId,
            'hasMore': hasMore.value,
            'total': response.data.meta.total,
          },
        );

        final meta = response.data.meta;
        final totalPages = (meta.total / messagesPerPage).ceil();

        if (currentPage.value == 1) {
          messages.assignAll(response.data.messages);
        } else {
          messages.addAll(response.data.messages);
        }

        hasMore.value = currentPage.value < totalPages;
        if (hasMore.value) currentPage.value++;
      } else {
        AppUtils.showError(response?.message ?? 'Failed to load messages');
        hasMore.value = false;
      }
    } catch (e, stackTrace) {
      ErrorLogger.logCaughtError(e, stackTrace, tag: 'CHAT_FETCH_ERROR');
      AppUtils.showError('Error loading messages. Please try again.');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Handle pull-to-refresh action
  Future<void> onRefresh() async {
    try {
      await fetchMessages(isRefresh: true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
      ErrorLogger.logCaughtError(e, StackTrace.current, tag: 'REFRESH_ERROR');
    }
  }

  // Handle load more action
  Future<void> onLoading() async {
    try {
      await fetchMessages();
      if (hasMore.value) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      refreshController.loadFailed();
      ErrorLogger.logCaughtError(e, StackTrace.current, tag: 'LOAD_MORE_ERROR');
    }
  }

  // Send a message to the chat
  Future<void> sendMessage() async {
    if (messageTextEditingController.text.trim().isEmpty) return;

    try {
      final currentUserId = LocalStorage.userId;
      if (currentUserId.isEmpty) {
        AppUtils.showError('Please login to send messages');
        return;
      }

      final message = Message(
        text: messageTextEditingController.text,
        sender: currentUserId,
        chatId: chatId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        id: '',
        v: 0,
      );

      messages.add(message);  // Optimistic UI update
      messageTextEditingController.clear();

      final response = await messageService.sendMessage(chatId, message);
      
      if (response.success) {
        AppUtils.showSuccess("Message sent successfully");
        fetchMessages();
      } else {
        AppUtils.showError("Failed to send message: ${response.message}");
      }
    } catch (e, stackTrace) {
      AppUtils.showError("Error in sendMessage method: $e\n$stackTrace");
    }
  }

  @override
  void onClose() {
    messageTextEditingController.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }
}
