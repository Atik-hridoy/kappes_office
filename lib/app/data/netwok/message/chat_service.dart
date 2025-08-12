// import 'dart:convert';
// import 'package:canuck_mall/app/model/message_and_chat/chat_model.dart';
// import 'package:dio/dio.dart';
// import 'package:canuck_mall/app/constants/app_urls.dart';
// import 'package:canuck_mall/app/data/local/storage_service.dart'; // LocalStorage
// import 'package:canuck_mall/app/utils/log/app_log.dart';

// class ChatService {
//   final Dio _dio;

//   // Constructor initializing Dio instance
//   ChatService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: AppUrls.baseUrl));

//   // Function to fetch chats for the user
//   Future<ChatResponse> fetchChatsForUser() async {
//     try {
//       AppLogger.info('Fetching chats...', tag: 'ChatService');

//       // Retrieve the token from LocalStorage
//       String token = LocalStorage.token;
//       if (token.isEmpty) {
//         throw Exception('No token found, please login.');
//       }

//       final response = await _dio.get(
//         '${AppUrls.baseUrl}${AppUrls.getMessages}', // Adjust based on your URL structure
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',  // Add Bearer token
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         AppLogger.info('Chats fetched successfully.', tag: 'ChatService', context: response.data);
//         return ChatResponse.fromJson(response.data); // Parse and return chat data
//       } else {
//         throw Exception('Failed to load chats.');
//       }
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow; // Rethrow the error
//     }
//   }

//   // Function to send a message to a specific chatId
//   Future<bool> sendMessageToShop(String chatId, String messageText) async {
//     try {
//       AppLogger.info('Sending message to chatId: $chatId', tag: 'ChatService');

//       String token = LocalStorage.token;
//       if (token.isEmpty) {
//         throw Exception('No token found, please login.');
//       }

//       final response = await _dio.post(
//         '${AppUrls.baseUrl}${AppUrls.createMessage}',
//         data: jsonEncode({
//           'chatId': chatId,
//           'message': messageText,
//         }),
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',  // Add Bearer token in headers
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         AppLogger.info('Message sent successfully.', tag: 'ChatService');
//         return true;  // Message sent successfully
//       } else {
//         throw Exception('Failed to send message');
//       }
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow; // Rethrow the error
//     }
//   }

//   // Error handler for Dio errors
//   void _handleDioError(DioException e) {
//     if (e.response != null) {
//       AppLogger.error('Dio Error: ${e.response?.data}', tag: 'ChatService', error: 'Dio Error: ${e.response?.data}');
//     } else {
//       AppLogger.error('Dio Error: ${e.message}', tag: 'ChatService', error: 'Dio Error: ${e.message}');
//     }
//   }
// }
