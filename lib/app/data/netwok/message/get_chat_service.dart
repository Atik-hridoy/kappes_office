import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart';

class ChatService {
  final Dio _dio;

  ChatService({Dio? dio}) : _dio = dio ?? Dio();

  // Fetch chat data for a user
  Future<ChatResponse> getChatsForUser() async {
    try {
      AppLogger.info('Fetching chats...', tag: 'ChatService');

      if (LocalStorage.token.isEmpty) {
        await LocalStorage.getAllPrefData();
      }
      final token = LocalStorage.token;
      if (token.isEmpty) {
        throw Exception('No token found, please login.');
      }

      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getChatForUser}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppLogger.info('Chat API status: ${response.statusCode}', tag: 'ChatService');
      AppLogger.info('Chat API data: ${response.data}', tag: 'ChatService');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : jsonDecode(response.data as String) as Map<String, dynamic>;
        return ChatResponse.fromJson(data);
      }

      throw Exception('Failed to load chat data (${response.statusCode})');
    } on DioException catch (e) {
      final errorData = e.response?.data;
      AppLogger.error('Dio Error: ${e.message}', tag: 'ChatService', context: {'response': errorData}, error: 'Dio Error');
      throw Exception('Failed to load chat data: ${errorData ?? e.message}');
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
