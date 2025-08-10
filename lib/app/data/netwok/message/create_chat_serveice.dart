import 'dart:convert';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/message_and_chat/create_chat_model.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart'; // Import the AppUrls class

class CreateChatService {
  final Dio dio;

  // Constructor initializing Dio instance
  CreateChatService({Dio? dio}) : dio = dio ?? Dio(BaseOptions(baseUrl: AppUrls.baseUrl));

  // Method to create a chat
  Future<ChatResponse> createChat(ChatData chatData) async {
    try {
      // Convert the ChatData model to JSON
      final chatDataJson = jsonEncode(chatData.toJson());

      // Sending POST request to create a chat
      final response = await dio.post(
        AppUrls.createChat,  // Use AppUrls for the endpoint
        data: chatDataJson, // Sending the chat data in JSON format
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${LocalStorage.token}', // Ensure token is included
          },
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response data to the ChatResponse model
        return ChatResponse.fromJson(response.data);
      } else {
        // Log error and throw custom exception if response is not OK
        AppLogger.error(
          'Failed to create chat: ${response.statusCode}',
          tag: 'CREATE_CHAT_SERVICE',
          context: {'response': response.data},
        );
        throw Exception('Failed to create chat: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      AppLogger.error(
        'DioError: ${e.message}',
        tag: 'CREATE_CHAT_SERVICE',
        context: {'error': e.response?.data ?? 'No response data'},
      );
      throw Exception('Error creating chat: ${e.message}');
    } catch (e) {
      // General error handling for any other issues
      AppLogger.error(
        'General error: $e',
        tag: 'CREATE_CHAT_SERVICE',
        context: {'error': e.toString()},
      );
      throw Exception('Error creating chat: $e');
    }
  }
}

void main() async {
  // Example usage of the service
  final chatService = CreateChatService();

  // Example data to send when creating a chat (as per the model)
  final chatData = ChatData(
    id: "686b4723ff0ea5b6a9ee6972",
    participants: [
      Participant(
        id: "686b4723ff0ea5b6a9ee6973",
        participantId: ParticipantId(
          id: "685a209195fac3398ed00fca",
          fullName: "ooaaow",
          role: "USER",
          email: "asifaowadud.ooaaow@gmail.com",
          phone: "+8801532469871",
          verified: true,
          isDeleted: false,
        ),
        participantType: "User",
      ),
      Participant(
        id: "686b4723ff0ea5b6a9ee6974",
        participantId: ParticipantId(
          id: "shop_685806ee0d8150920d3662a5", // Shop id with the "shop_" prefix
          fullName: "asif store",
          role: "Shop",
          email: "asifaowadud@gmail.com",
          phone: "+01800000000",
          verified: true,
          isDeleted: false,
        ),
        participantType: "Shop",
      ),
    ],
    status: true,
  );

  try {
    // Attempt to create a chat using the service
    ChatResponse createdChat = await chatService.createChat(chatData);
    AppLogger.info(
      'Chat created successfully',
      tag: 'CREATE_CHAT_SERVICE',
      context: {'message': createdChat.message},
    );
  } catch (e) {
    AppLogger.error(
      'Failed to create chat',
      tag: 'CREATE_CHAT_SERVICE',
      context: {'error': e.toString()},
    );
  }
}
