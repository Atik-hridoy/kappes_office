import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
import 'package:canuck_mall/app/data/netwok/message/get_message_service.dart'; // Import the GetMessageService
import 'package:canuck_mall/app/model/message_and_chat/create_chat_model.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_message.dart'; 
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChattingViewController extends GetxController {
  final messageTextEditingController = TextEditingController();
  RxBool isBoxOpen = false.obs;
  RxList<Message> messages = <Message>[].obs; // Reactive list of messages
  final CreateChatService chatService; // CreateChatService to create the chat
  final GetMessageService messageService; // GetMessageService to fetch the messages

  // Constructor to inject CreateChatService and GetMessageService
  ChattingViewController({required this.chatService, required this.messageService});

  // Chat ID passed from the previous screen
  late String chatId;

  // Pagination variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  static const int messagesPerPage = 20; // Example: Load 20 messages per request

  @override
  void onInit() {
    super.onInit();

    // Retrieve the chatId from arguments (passed from the previous screen)
    chatId = Get.arguments['chatId'] ?? '';

    if (chatId.isEmpty) {
      // If there's no chatId, create a new chat
      createChat();
    } else {
      // Fetch existing messages for this chat
      fetchMessages();
    }

    // Set UI overlay style for status bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white, // Transparent status bar
        statusBarIconBrightness: Brightness.dark, // Dark icons for light backgrounds
      ));
    });
  }

  // Function to create a new chat
  Future<void> createChat() async {
    try {
      final chatData = ChatData(
        id: '',
        participants: [
          // Add your participants (replace with actual data)
          Participant(
            id: "userId", // Replace with actual userId
            participantId: ParticipantId(
              id: "userId", // Replace with actual userId
              fullName: "User Name", // Replace with actual full name
              role: "USER", // Replace with actual role
              email: "user@example.com", // Replace with actual email
              phone: "+123456789", // Replace with actual phone
              verified: true,
              isDeleted: false,
            ),
            participantType: "User",
          ),
          Participant(
            id: "shopId", // Replace with actual shopId
            participantId: ParticipantId(
              id: "shopId", // Replace with actual shopId
              fullName: "Shop Name", // Replace with actual shop name
              role: "Shop", // Replace with shop's role
              email: "shop@example.com", // Replace with actual shop email
              phone: "+987654321", // Replace with actual shop phone
              verified: true,
              isDeleted: false,
            ),
            participantType: "Shop",
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

  // Fetch messages for the specific chatId
  Future<void> fetchMessages() async {
    try {
      isLoading(true); // Show loading spinner while fetching

      // Call the fetchMessages method from GetMessageService
      final response = await messageService.fetchMessages(
        chatId,
        currentPage.value,
        messagesPerPage,
      );

      if (response != null && response.success) {
        // Update the messages list with the fetched messages
        if (currentPage.value == 1) {
          messages.assignAll(response.data.messages); // Replace messages if it's the first page
        } else {
          messages.addAll(response.data.messages); // Append new messages if it's a subsequent page
        }
      } else {
        AppUtils.showError('Failed to load messages');
      }
    } catch (e) {
      AppUtils.showError('Error fetching messages: $e');
    } finally {
      isLoading(false); // Stop loading
    }
  }

  // Send message method that interacts with MessageService
  Future<void> sendMessage() async {
    try {
      // Create a new message model from the text controller
      final message = Message(
        text: messageTextEditingController.text,
        sender: "userId",  // Populate the sender as needed (e.g., use current userId)
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

  // Pagination: Load more messages when the user scrolls to the bottom
  void loadMoreMessages() {
    currentPage.value++;  // Increment the page number
    fetchMessages();  // Fetch next page of messages
  }

  @override
  void onClose() {
    // Clean up controllers
    messageTextEditingController.dispose();
    super.onClose();
  }
}
