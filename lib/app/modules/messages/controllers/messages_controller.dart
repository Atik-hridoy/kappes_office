import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/message/get_chat_service.dart';
import 'package:canuck_mall/app/data/netwok/message/get_message.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_message.dart'
    as message_model;
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  final MessageService _messageService = MessageService();
  final ChatService _chatService = ChatService();

  final RxList<message_model.Message> messages = <message_model.Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final int limit = 20;
  final String userId;

  // Store the chat ID once fetched
  String? _chatId;

  MessagesController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;
      // First, get the chat ID for the user
      await _fetchChatId();
      // Then fetch messages
      if (_chatId != null) {
        await fetchMessages();
      } else {
        AppLogger.error('No chat found for user');
        // You might want to create a new chat here if needed
      }
    } catch (e) {
      AppLogger.error('Error initializing chat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchChatId() async {
    try {
      final token = LocalStorage.token;
      if (token.isEmpty) {
        throw Exception('Authentication required');
      }

      final response = await _chatService.getChats(token);
      if (response.data.chats.isNotEmpty) {
        // Get the first chat's ID
        // Note: You might want to implement logic to find a specific chat
        _chatId = response.data.chats.first.id;
        AppLogger.info('Chat ID fetched: $_chatId');
      } else {
        AppLogger.warning('No chats found for user');
        // Consider creating a new chat here if needed
      }
    } catch (e) {
      AppLogger.error('Error fetching chat ID: $e');
      rethrow;
    }
  }

  Future<void> fetchMessages() async {
    if (isLoading.value || !hasMore.value || _chatId == null) return;

    try {
      isLoading.value = true;

      final response = await _messageService.fetchMessages(
        _chatId!, // Use the fetched chat ID
        currentPage.value,
        limit,
      );

      if (response != null) {
        if (response.data.messages.isNotEmpty) {
          messages.addAll(response.data.messages);
          currentPage.value = currentPage.value + 1;

          // Check if there are more pages to load
          final totalPages = (response.data.meta.total / limit).ceil();
          hasMore.value = currentPage.value <= totalPages;
        } else {
          hasMore.value = false;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages', colorText: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMessages() async {
    currentPage.value = 1;
    messages.clear();
    hasMore.value = true;
    await fetchMessages();
  }

  // Add a new message to the list (for real-time updates)
  void addNewMessage(message_model.Message message) {
    messages.insert(0, message);
  }
}
