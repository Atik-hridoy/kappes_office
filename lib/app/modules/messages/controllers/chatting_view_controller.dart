import 'dart:io';

import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
import 'package:canuck_mall/app/data/netwok/message/get_message_service.dart';
import 'package:canuck_mall/app/data/netwok/message/create_messages_service.dart' as create_msg;
import 'package:canuck_mall/app/model/message_and_chat/create_chat_model.dart' as create_chat;
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart' as get_chat;
import 'package:canuck_mall/app/model/message_and_chat/get_message.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/utils/log/error_log.dart';
import 'package:canuck_mall/app/socket/message_socket_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChattingViewController extends GetxController {
  final messageTextEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final ImagePicker _imagePicker = ImagePicker();
  bool _isPickingImage = false;
  
  // Socket controller for real-time messaging
  final MessageSocketController socketController = Get.put(MessageSocketController());

  RxBool isBoxOpen = false.obs;
  RxList<Message> messages = <Message>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxInt currentPage = 1.obs;

  static const int messagesPerPage = 20;
  late final CreateChatToSellerService chatService;
  late final GetMessageService messageService;
  late final create_msg.CreateMessageService createMessageService;
  
  String chatId = '';
  String? shopId;
  RxString? shopName;

  String get currentUserId => LocalStorage.userId;

  // Constructor to initialize services
  ChattingViewController({
    required this.chatService,
    required this.messageService,
    create_msg.CreateMessageService? createMessageService,
  }) : createMessageService = createMessageService ?? create_msg.CreateMessageService();

  @override
  void onInit() {
    super.onInit();
    _initializeChatData();
    _setupScrollListener();
    _setUIOverlayStyle();
    _setupSocketListeners();

    // Fetch initial messages or create a new chat
    if (chatId.isNotEmpty) {
      fetchMessages(isRefresh: true);
      _joinSocketRoom();
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
      shopName = RxString(args['shopName']?.toString() ?? '');
      update(); // Trigger UI update for shopName
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
          shopName = RxString((shopParticipant.participantId as get_chat.Shop).name);
        } else if (shopParticipant.participantId is get_chat.User) {
          shopName = RxString((shopParticipant.participantId as get_chat.User).fullName);
        } else {
          shopName = RxString('Shop');
        }
        update(); // Trigger UI update for shopName
      }
    } else {
      return false;
    }

    return chatId != prevChatId || shopId != prevShopId || shopName?.value != prevShopName?.value;
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

  // Scroll to bottom of the list (newest messages)
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
              fullName: shopName?.value ?? 'Shop',
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
        _joinSocketRoom(); // Join socket room after chat creation
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
        // Scroll to bottom after loading messages
        if (isRefresh) {
          _scrollToBottom();
        }
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

  
  @override
  void onClose() {
    _leaveSocketRoom();
    messageTextEditingController.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  // Socket methods
  void _setupSocketListeners() {
    // Listen for new messages from socket
    socketController.newMessages.listen((newMessages) {
      for (final message in newMessages) {
        if (message.chatId == chatId) {
          messages.insert(messages.length, message);
          _scrollToBottom();
        }
      }
    });
  }

  void _joinSocketRoom() {
    if (chatId.isNotEmpty) {
      socketController.joinChatRoom(chatId);
      socketController.setCurrentChatId(chatId);
    }
  }

  void _leaveSocketRoom() {
    if (chatId.isNotEmpty) {
      socketController.leaveChatRoom(chatId);
    }
  }

  Future<void> pickAndSendImage() async {
    if (_isPickingImage) return;
    if (chatId.isEmpty) {
      AppUtils.showError('Chat is not ready yet');
      return;
    }

    _isPickingImage = true;
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked != null) {
        await sendMessage(imageFile: File(picked.path));
      }
    } catch (e, stackTrace) {
      ErrorLogger.logCaughtError(e, stackTrace, tag: 'PICK_IMAGE_ERROR');
      AppUtils.showError('Failed to pick image');
    } finally {
      _isPickingImage = false;
    }
  }

  // Enhanced sendMessage with socket support
  Future<void> sendMessage({File? imageFile}) async {
    final trimmedText = messageTextEditingController.text.trim();
    final hasText = trimmedText.isNotEmpty;
    final hasImage = imageFile != null;

    if (!hasText && !hasImage) return;

    try {
      final currentUserId = LocalStorage.userId;
      if (currentUserId.isEmpty) {
        AppUtils.showError('Please login to send messages');
        return;
      }

      Message? optimisticMessage;
      if (hasText) {
        socketController.sendMessage(
          chatId: chatId,
          text: trimmedText,
          senderId: currentUserId,
        );

        optimisticMessage = Message(
          text: trimmedText,
          sender: currentUserId,
          chatId: chatId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          id: '',
          v: 0,
        );

        messages.add(optimisticMessage);
        messageTextEditingController.clear();
        update();
      }

      final response = await createMessageService.sendMessage(
        chatId: chatId,
        text: trimmedText,
        image: imageFile,
      );
      
      if (response.success) {
        AppUtils.showSuccess("Message sent successfully");
        // Refresh messages to get the server response with proper ID
        await fetchMessages(isRefresh: true);
        // Scroll to bottom to show the latest message
        _scrollToBottom();
      } else {
        // Remove the optimistic message if sending failed
        if (optimisticMessage != null) {
          messages.remove(optimisticMessage);
        }
        AppUtils.showError("Failed to send message: ${response.message}");
        update();
      }
    } catch (e, stackTrace) {
      ErrorLogger.logCaughtError(e, stackTrace, tag: 'SEND_MESSAGE_ERROR');
      AppUtils.showError("Error sending message: $e");
    }
  }
}
