import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart'; // Import the LocalStorage
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart';

class ChatService {
  final Dio _dio;

  ChatService({Dio? dio}) : _dio = dio ?? Dio();

  // Fetch chat data for a user
  Future<ChatResponse> getChatsForUser() async {
    try {
      AppLogger.info('Fetching chats...', tag: 'ChatService');

      // Retrieve the token from LocalStorage
      String token = LocalStorage.token; // Get the token from local storage
      if (token.isEmpty) {
        throw Exception('No token found, please login.');
      }

      // Make a GET request to fetch chats
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getChatForUser}',  // Use the dynamic URL here
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',  // Add Bearer token in headers
          },
        ),
      );

      // If the response is successful (status code 200)
      if (response.statusCode == 200) {
        AppLogger.info('Chats fetched successfully.', tag: 'ChatService', context: response.data);
        return ChatResponse.fromJson(response.data);  // Parse the response into the ChatResponse model
      } else {
        throw Exception('Failed to load chat data');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        AppLogger.error('Dio Error: ${e.response?.data}', tag: 'ChatService', error: 'Dio Error: ${e.response?.data}');
        throw Exception('Dio Error: ${e.response?.data}');
      } else {
        AppLogger.error('Error: ${e.message}', tag: 'ChatService', error: 'Error: ${e.message}');
        throw Exception('Failed to load chat data: ${e.message}');
      }
    }
  }

  // Function to send a message (if required)
  Future<bool> sendMessage(String message) async {
    try {
      String token = LocalStorage.token;
      if (token.isEmpty) {
        throw Exception('No token found, please login.');
      }

      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.createMessage}',  // Adjust the URL if needed
        data: jsonEncode({'message': message}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',  // Add Bearer token in headers
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;  // Message sent successfully
      } else {
        throw Exception('Failed to send message');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Dio Error: ${e.response?.data}');
      } else {
        throw Exception('Failed to send message: ${e.message}');
      }
    }
  }
}
