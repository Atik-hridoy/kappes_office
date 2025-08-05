import 'dart:convert';
import 'package:canuck_mall/app/model/message_and_chat/create_chat_model.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';

class ChatService {
  static const String baseUrl =
      'http://10.10.7.112:7000/api/v1'; // Replace with your API base URL
  static const String createChatUrl = '/chat'; // Endpoint for creating a chat

  final Dio dio;

  // Constructor initializing Dio instance
  ChatService({Dio? dio}) : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  // Method to create a chat
  Future<CreateChat> createChat(Map<String, dynamic> chatData) async {
    try {
      // Sending POST request to create a chat
      final response = await dio.post(
        createChatUrl,
        data: jsonEncode(chatData), // Sending the chat data in JSON format
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Add other headers if necessary (e.g., for authentication)
          },
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response data to the CreateChat model
        return CreateChat.fromJson(response.data);
      } else {
        throw Exception('Failed to create chat: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors (e.g., network issues, incorrect data)
      throw Exception('Error creating chat: $e');
    }
  }
}

void main() async {
  // Example usage of the service
  final chatService = ChatService();

  // Example data to send when creating a chat
  final chatData = {
    "success": true,
    "message": "Create Chat Successfully",
    "data": {
      "_id": "686b4723ff0ea5b6a9ee6972",
      "participants": [
        {
          "participantId": "685a209195fac3398ed00fca",
          "participantType": "User",
          "_id": "686b4723ff0ea5b6a9ee6973",
        },
        {
          "participantId": "6857d5988a47be1e4bf6adc4",
          "participantType": "Shop",
          "_id": "686b4723ff0ea5b6a9ee6974",
        },
      ],
      "status": true,
      "__v": 0,
    },
  };

  try {
    // Attempt to create a chat using the service
    CreateChat createdChat = await chatService.createChat(chatData);
    AppLogger.info(
      'Chat created successfully',
      tag: 'CHAT_SERVICE',
      context: {'message': createdChat.message},
    );
  } catch (e) {
    AppLogger.error(
      'Failed to create chat',
      tag: 'CHAT_SERVICE',
      context: {'error': e.toString()},
    );
  }
}
