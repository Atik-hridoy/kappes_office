import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
import 'package:canuck_mall/app/data/netwok/message/get_message_service.dart';
import 'package:canuck_mall/app/model/message_and_chat/create_chat_model.dart' as create_chat;
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart' as get_chat;
import 'package:canuck_mall/app/model/message_and_chat/get_message.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
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
  RxList<Message> messages = <Message>[].obs; // Reactive list of messages
  final CreateChatService chatService; // CreateChatService to create the chat
  final GetMessageService messageService; // GetMessageService to fetch the messages

  // Constructor to inject CreateChatService and GetMessageService
  ChattingViewController({required this.chatService, required this.messageService});

  // Chat ID and other chat data passed from the previous screen
  String chatId = '';
  String? shopId;
  String? shopName;

  // Get current user ID
  String get currentUserId => LocalStorage.userId;

  // Pagination variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  static const int messagesPerPage = 20; // Load 20 messages per request

  @override
  void onInit() {
    super.onInit();
    
    // Reset values
    chatId = '';
    shopId = null;
    shopName = null;

    // Handle different types of arguments
    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      chatId = args['chatId']?.toString() ?? '';
      shopId = args['shopId']?.toString();
      shopName = args['shopName']?.toString();
    } else if (Get.arguments is get_chat.Chat) {
      final chat = Get.arguments as get_chat.Chat;
      chatId = chat.id;
      final shopParticipant = chat.participants.firstWhereOrNull(
        (p) => p.participantType.toString().toLowerCase() == 'shop'
      );
      if (shopParticipant != null) {
        shopId = shopParticipant.id;
        shopName = shopParticipant.participantId?.fullName ?? 'Shop';
      }
    }

    // Set up scroll listener for infinite scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels >= 
          scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value && 
          hasMore.value) {
        fetchMessages();
      }
    });

    // Set UI overlay style for status bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
      ));

      // Initial fetch if we have a chatId, otherwise create a new chat
      if (chatId.isNotEmpty) {
        fetchMessages(isRefresh: true);
      } else if (shopId?.isNotEmpty ?? false) {
        createChat();
      } else {
        AppUtils.showError('Unable to start chat: Missing shop information');
        Get.back();
      }
    });
  }

  // Function to create a new chat
  Future<void> createChat() async {
    try {
      if (shopId == null || shopId!.isEmpty) {
        throw Exception('Shop ID is required to create a chat');
      }

      // Get current user info from local storage
      final userId = LocalStorage.userId;
      final userFullName = LocalStorage.myName.isNotEmpty ? LocalStorage.myName : 'User';
      final userEmail = LocalStorage.myEmail;
      final userPhone = LocalStorage.phone;

      final chatData = create_chat.ChatData(
        id: '',
        participants: [
          // Current user
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
          // Shop (seller)
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

      // Call CreateChatService to create the chat
      final chatResponse = await chatService.createChat(chatData);

      if (chatResponse.success) {
        AppUtils.showSuccess("Chat created successfully!");
        chatId = chatResponse.data.id; // Save the chatId from the response
        fetchMessages(); // Fetch the messages for the newly created chat
      } else {
        AppUtils.showError("Failed to create chat: ${chatResponse.message}");
      }
    } catch (e) {
      AppUtils.showError("Error creating chat: $e");
    }
  }

  // Fetch messages for the specific chatId with pagination
  Future<void> fetchMessages({bool isRefresh = false}) async {
    if (isLoading.value) return; // Prevent multiple simultaneous requests
    
    try {
      // If it's a refresh, reset to first page and clear existing messages
      if (isRefresh) {
        currentPage.value = 1;
        hasMore.value = true;
        messages.clear();
      }

      // Don't fetch if we've reached the end
      if (!hasMore.value) return;

      isLoading.value = true;

      // Call the fetchMessages method from GetMessageService
      final response = await messageService.fetchMessages(
        chatId,
        currentPage.value,
        messagesPerPage,
      );

      if (response != null && response.success) {
        // Update the messages list based on pagination
        if (response.data.messages.isNotEmpty) {
          if (currentPage.value == 1) {
            messages.assignAll(response.data.messages);
          } else {
            messages.addAll(response.data.messages);
          }
          
          // Update pagination info
          final meta = response.data.meta;
          if (meta != null) {
            final totalPages = (meta.total / messagesPerPage).ceil();
            hasMore.value = currentPage.value < totalPages;
            
            if (hasMore.value) {
              currentPage.value++;
            }
          }
        } else {
          hasMore.value = false;
        }
      } else {
        final errorMessage = response?.message ?? 'Failed to load messages';
        AppUtils.showError(errorMessage);
      }
    } catch (e, stackTrace) {
      ErrorLogger.logCaughtError(
        e,
        stackTrace,
        tag: 'CHAT_FETCH_ERROR',
      );
      AppUtils.showError('Error loading messages. Please try again.');
    } finally {
      isLoading.value = false;
      update(); // Notify listeners
    }
  }

  // Handle pull-to-refresh
  Future<void> refreshMessages() async {
    await fetchMessages(isRefresh: true);
  }

  // Send message method that interacts with MessageService
  Future<void> sendMessage() async {
    if (messageTextEditingController.text.trim().isEmpty) {
      return; // Don't send empty messages
    }
    
    try {
      // Get current user ID from local storage
      final currentUserId = LocalStorage.userId;
      
      if (currentUserId.isEmpty) {
        AppUtils.showError('Please login to send messages');
        return;
      }
      
      // Create a new message model from the text controller
      final message = Message(
        text: messageTextEditingController.text,
        sender: currentUserId,  // Use the current user's ID as the sender
        chatId: chatId,  // The chatId for this conversation
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        id: '',  // The ID will be generated by the backend
        v: 0,
      );

      // Add the message to the local list (optimistic UI update)
      messages.add(message);
      messageTextEditingController.clear();

      // Call MessageService to send the message
      final response = await messageService.sendMessage(chatId, message);
      
      if (response.success) {
        // Optionally, update the message state with the response (if needed)
        AppUtils.showSuccess(response.message);
        // Re-fetch messages if necessary (to get server-generated message ID or status)
        fetchMessages();
      } else {
        AppUtils.showError("Failed to send message: ${response.message}");
      }

      // Update the UI after sending the message (optimistic update should suffice)
      update();
    } catch (e, stackTrace) {
      // Handle errors gracefully
      AppUtils.showError("Error in sendMessage method: $e\n$stackTrace");
    }
  }

  // Load more messages when user scrolls to the bottom
  void loadMoreMessages() {
    if (!isLoading.value && hasMore.value) {
      fetchMessages();
    }
  }

  // Handle pull-to-refresh
  Future<void> onRefresh() async {
    try {
      await fetchMessages(isRefresh: true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
      ErrorLogger.logCaughtError(e, StackTrace.current, tag: 'REFRESH_ERROR');
    }
  }

  // Handle load more
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
    // Clean up controllers
    messageTextEditingController.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }
}
