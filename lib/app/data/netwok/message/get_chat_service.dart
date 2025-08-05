import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart'; // Import the ChatResponse model
import 'package:canuck_mall/app/utils/app_utils.dart'; // For showing error messages

class ChatService {
  static const String baseUrl = AppUrls.baseUrl; // API base URL
  static const String getChat = AppUrls.getChatForUser; // Endpoint for getting chats

  final Dio dio;

  // Constructor initializing Dio instance
  ChatService({Dio? dio}) : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  // Function to get chat data from the API
  Future<ChatResponse> getChats(String authToken) async {
    try {
      final response = await dio.get(
        AppUrls.getChatForUser,
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
