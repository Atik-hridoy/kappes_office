import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart'; // Import the ChatResponse model
import 'package:canuck_mall/app/utils/app_utils.dart'; // For error handling

class ChattingViewController extends GetxController {
  final messageTextEditingController = TextEditingController();
  RxBool isBoxOpen = false.obs;
  RxList<Chat> messages = <Chat>[].obs; // Dynamic and reactive message list

  final Dio dio = Dio(); // Dio instance for making API calls

  // Function to send a new message
  void sendMessage() {
    try {
      final message = Chat(id: '', message: messageTextEditingController.text);
      // Add the new message to the list
      messages.add(message);
      // Clear the text field after sending
      messageTextEditingController.clear();
      update(); // Update the UI
    } catch (e, stackTrace) {
      AppUtils.appError("Error in sendMessage method: $e\n$stackTrace");
    }
  }

  // Function to get chat data from the backend
  Future<void> fetchChats(String authToken) async {
    final String url =
        'http://10.10.7.112:7000/api/v1/chat/user'; // Replace with the actual endpoint

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                authToken, // Pass the authorization token dynamically
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response data into ChatResponse model
        final chatResponse = ChatResponse.fromJson(response.data);

        if (chatResponse.success) {
          // Clear previous messages and add new messages from the backend
          messages.clear();
          for (var chat in chatResponse.data.chats) {
            messages.add(Chat(id: chat.id, message: chat.message));
          }
          AppUtils.appError("Chats fetched successfully.");
        } else {
          // Handle the case when the chat retrieval fails
          AppUtils.appError("Failed to load chats.");
        }
      } else {
        // Handle non-200 status codes
        AppUtils.appError("Error: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      // Handle network errors or other exceptions
      AppUtils.appError("Error fetching chats: $e\n$stackTrace");
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // Transparent status bar
          statusBarIconBrightness:
              Brightness.dark, // Dark icons for light backgrounds
        ),
      );
    });
    super.onInit();
  }

  @override
  void onClose() {
    messageTextEditingController.dispose();
    super.onClose();
  }
}
