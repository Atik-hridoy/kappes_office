import 'package:dio/dio.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart'; // Import the ChatResponse model
import 'package:canuck_mall/app/utils/app_utils.dart'; // For showing error messages

class ChatService {
  static const String baseUrl =
      'http://10.10.7.112:7000/api/v1'; // API base URL
  static const String getChat = '/chat/user'; // Endpoint for getting chats

  final Dio dio;

  // Constructor initializing Dio instance
  ChatService({Dio? dio}) : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  // Function to get chat data from the API
  Future<ChatResponse> getChats(String authToken) async {
    try {
      final response = await dio.get(
        getChat,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                authToken, // Pass the authorization token dynamically
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response data and return the ChatResponse object
        return ChatResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load chats: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      // Handle errors (e.g., network issues, server issues)
      AppUtils.appError("Error in getChats method: $e\n$stackTrace");
      throw Exception('Error in fetching chats: $e');
    }
  }
}
