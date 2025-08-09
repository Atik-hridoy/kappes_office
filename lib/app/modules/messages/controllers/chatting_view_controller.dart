import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
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
  RxList<Message> messages = <Message>[].obs;
  final CreateChatService chatService;

  // Constructor to inject CreateChatService
  ChattingViewController({required this.chatService});

  // Send message method that interacts with CreateChatService
  void sendMessage() async {
    try {
      // Create a new message model from the text controller
      final message = Message(
        text: messageTextEditingController.text,
        sender: "",  // Populate the sender as needed
        chatId: "",  // Populate the chatId as needed
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        id: '',
        v: 0,
      );

      // Add the message to the local list (optimistic UI update)
      messages.add(message);
      messageTextEditingController.clear();

      // Call CreateChatService to send the message
      final chatData = ChatData(
        id: "",  // Populate chatId
        participants: [],  // Add participants to the chat
        status: true,
      );

      // Use the CreateChatService to send the chat data
      final chatResponse = await chatService.createChat(chatData);
      
      if (chatResponse.success) {
        // Update the message state with the response (if needed)
        AppUtils.showSuccess(chatResponse.message);
      } else {
        AppUtils.showError("Failed to create chat: ${chatResponse.message}");
      }

      // Update the UI after sending message
      update();
    } catch (e, stackTrace) {
      // Handle errors gracefully
      AppUtils.showError("Error in sendMessage method: $e\n$stackTrace");
    }
  }

  @override
  void onInit() {
    // Set UI overlay style for status bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white, // Transparent status bar
        statusBarIconBrightness: Brightness.dark, // Dark icons for light backgrounds
      ));
    });
    super.onInit();
  }

  @override
  void onClose() {
    // Clean up controllers
    messageTextEditingController.dispose();
    super.onClose();
  }
}
