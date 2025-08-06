import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:canuck_mall/app/data/netwok/message/get_chat_service.dart'; // Import ChatService
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart'; // Import ChatResponse model

class MessagesController extends GetxController {
  final ChatService _chatService = ChatService();  // Instance of ChatService

  // Observables
  RxList<Chat> messages = <Chat>[].obs;  // Holds the list of messages
  RxBool isLoading = false.obs;  // Show loading indicator
  RxString errorMessage = ''.obs;  // Show error message if any
  final searchTextController = TextEditingController();  // Controller for search input

  // Fetch the list of chats for a specific user
  Future<void> fetchChats() async {
    try {
      isLoading.value = true;  // Start loading

      // Call the service to fetch chats
      ChatResponse chatResponse = await _chatService.getChatsForUser();

      if (chatResponse.success) {
        messages.clear();  // Clear previous messages
        messages.addAll(chatResponse.data.chats);  // Add the fetched messages
      } else {
        errorMessage.value = "Failed to load chats.";  // Show error message if failed
      }
    } catch (e) {
      errorMessage.value = "Error: $e";  // Handle errors
    } finally {
      isLoading.value = false;  // End loading
    }
  }

  // Search for messages based on the query entered
  void searchMessages(String query) {
    if (query.isEmpty) {
      fetchChats(); // Fetch all messages if the search is cleared
    } else {
      var filteredMessages = messages.where((message) {
        // Filter messages that contain the query text
        return message.lastMessage?.text.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
      messages.assignAll(filteredMessages);  // Update the messages list
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchChats();  // Fetch chats when the controller is initialized
  }

  @override
  void onClose() {
    super.onClose();
    searchTextController.dispose();  // Dispose of the search controller when the controller is closed
  }
}
