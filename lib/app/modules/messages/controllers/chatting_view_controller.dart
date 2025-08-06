import 'package:canuck_mall/app/model/message_and_chat/get_message.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChattingViewController extends GetxController{
  final messageTextEditingController = TextEditingController();
  RxBool isBoxOpen = false.obs;
  RxList<Message> messages = <Message>[].obs;

  void sentMessage(){
    try{
      final message = Message(text: messageTextEditingController.text, sender: "", chatId: "", createdAt: DateTime.now(), updatedAt: DateTime.now(), id: '', v: 0);
      messages.add(message);
      messageTextEditingController.clear();
      update();
    }catch(e,stackTrace){
      AppUtils.appError("error comes from sendMessage method : $e\n$stackTrace");
    }
  }


  @override
  void onInit() {
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
    messageTextEditingController.dispose();
    super.onClose();
  }
}



// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart'; // Import the ChatResponse model
// import 'package:canuck_mall/app/utils/app_utils.dart'; // For error handling
// import 'package:canuck_mall/app/constants/app_urls.dart'; // Import AppUrls class

// class ChattingViewController extends GetxController {
//   final messageTextEditingController = TextEditingController();
//   RxBool isBoxOpen = false.obs; // To handle the input box state
//   RxList<Chat> messages = <Chat>[].obs; // Reactive list to hold chat messages
//   RxBool isLoading = false.obs; // To show a loading indicator while fetching chats

//   final Dio dio = Dio(); // Dio instance for making API calls

//   // Function to send a new message
//   void sendMessage(String chatId, String authToken) async {
//     try {
//       if (messageTextEditingController.text.trim().isEmpty) {
//         AppUtils.appError("Message cannot be empty");
//         return;
//       }

//       // Create the message object
//       final message = {
//         'chatId': chatId,
//         'message': messageTextEditingController.text.trim(),
//       };

//       // Use the endpoint from AppUrls for sending a message
//       final String url = '${AppUrls.baseUrl}${AppUrls.createMessage}'; // Using dynamic URL from AppUrls

//       // Call the API to send the message
//       final response = await dio.post(
//         url, // Use the send message endpoint here
//         data: jsonEncode(message),
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': authToken,
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         // Successfully sent the message
//         AppUtils.appError("Message sent successfully.");
//         messageTextEditingController.clear(); // Clear the input field
//         fetchChats(authToken); // Refresh the chat list to include the new message
//       } else {
//         // Failed to send message
//         AppUtils.appError("Failed to send message. Please try again.");
//       }
//     } catch (e, stackTrace) {
//       AppUtils.appError("Error sending message: $e\n$stackTrace");
//     }
//   }

//   // Function to create a new chat
//   Future<void> createChat(Map<String, dynamic> chatData, String authToken) async {
//     try {
//       // Sending POST request to create a chat
//       final response = await dio.post(
//         '${AppUrls.baseUrl}${AppUrls.createChat}', // Using AppUrls for the create chat endpoint
//         data: jsonEncode(chatData), // Sending the chat data in JSON format
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': authToken, // Include auth token
//           },
//         ),
//       );

//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         // Parse the response data to the CreateChat model and handle accordingly
//         final createdChat = ChatResponse.fromJson(response.data);
//         AppUtils.appError("Chat created successfully!");
//         fetchChats(authToken); // Refresh the chat list after creation
//       } else {
//         AppUtils.appError("Failed to create chat: ${response.statusCode}");
//       }
//     } catch (e, stackTrace) {
//       AppUtils.appError("Error creating chat: $e\n$stackTrace");
//     }
//   }

//   // Function to fetch chat data from the backend
//   Future<void> fetchChats(String authToken) async {
//     final String url = '${AppUrls.baseUrl}${AppUrls.getChatForUser}'; // Using dynamic URL from AppUrls

//     try {
//       isLoading.value = true; // Show loading indicator

//       final response = await dio.get(
//         url, // Use the fetch chats endpoint here
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': authToken, // Pass the authorization token dynamically
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         // Parse the response data into ChatResponse model
//         final chatResponse = ChatResponse.fromJson(response.data);

//         if (chatResponse.success) {
//           // Clear previous messages and add new messages from the backend
//           messages.clear();
//           for (var chat in chatResponse.data.chats) {
//             messages.add(Chat(id: chat.id, participants: chat.participants, status: chat.status, lastMessage: chat.lastMessage));
//           }
//           AppUtils.appError("Chats fetched successfully.");
//         } else {
//           // Handle failure in fetching chats
//           AppUtils.appError("Failed to load chats.");
//         }
//       } else {
//         // Handle non-200 status codes
//         AppUtils.appError("Error: ${response.statusCode}");
//       }
//     } on DioError catch (e) {
//       // Handle network errors or other exceptions
//       if (e.response != null) {
//         AppUtils.appError("Dio Error: ${e.response?.data}");
//       } else {
//         AppUtils.appError("Failed to fetch chats: ${e.message}");
//       }
//     } finally {
//       isLoading.value = false; // Hide loading indicator
//     }
//   }

//   @override
//   void onInit() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(
//           statusBarColor: Colors.white, // Transparent status bar
//           statusBarIconBrightness:
//               Brightness.dark, // Dark icons for light backgrounds
//         ),
//       );
//     });
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     messageTextEditingController.dispose();
//     super.onClose();
//   }
// }
