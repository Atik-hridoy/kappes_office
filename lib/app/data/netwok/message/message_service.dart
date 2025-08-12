// import 'dart:convert';
// import 'package:canuck_mall/app/model/message_and_chat/chat_model.dart';
// import 'package:canuck_mall/app/model/message_and_chat/message_model.dart';
// import 'package:dio/dio.dart';
// import 'package:canuck_mall/app/data/local/storage_service.dart'; 
// import 'package:canuck_mall/app/utils/log/app_log.dart'; 
// import 'package:canuck_mall/app/constants/app_urls.dart'; // Import your AppUrls

// class MessageService {
//   final Dio dio;

//   // Constructor initializing Dio instance
//   MessageService({Dio? dio}) : dio = dio ?? Dio(BaseOptions(baseUrl: AppUrls.baseUrl)) {
//     // Add interceptors to include the auth token and handle errors
//     dio?.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // Get the token from local storage
//           final token = LocalStorage.token;
//           if (token.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           return handler.next(options);
//         },
//         onError: (error, handler) async {
//           if (error.response?.statusCode == 401) {
//             // Handle token expiration or unauthorized error
//             AppLogger.error('Unauthorized error: ${error.message}', tag: 'CHAT_SERVICE', error: error);
//           }
//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   // Fetch messages for a given chatId with pagination
//   Future<GetMessageResponse> fetchMessages({
//     required String chatId,
//     required int page,
//     required int limit,
//   }) async {
//     try {
//       final response = await dio.get(
//         '${AppUrls.baseUrl}/message/chat/$chatId',
//         queryParameters: {
//           'page': page,
//           'limit': limit,
//         },
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//         ),
//       );

//       if (response.statusCode == 200) {
//         // Parse the response data and return a response model
//         return GetMessageResponse.fromJson(response.data);
//       } else {
//         AppLogger.error(
//           'Error fetching messages, Status Code: ${response.statusCode}',
//           tag: 'CHAT_SERVICE',
//           error: 'Failed to fetch messages',
//         );
//         throw Exception('Failed to fetch messages');
//       }
//     } on DioException catch (e) {
//       AppLogger.error(
//         'Dio error fetching messages: ${e.message}',
//         tag: 'CHAT_SERVICE',
//         error: 'Failed to fetch messages',
//       );
//       throw Exception('Error fetching messages: ${e.message}');
//     } catch (e) {
//       AppLogger.error('Unexpected error: $e', tag: 'CHAT_SERVICE', error: 'Failed to fetch messages');
//       throw Exception('Error fetching messages: $e');
//     }
//   }

//   // Send a message to a specific chatId
//   Future<void> sendMessage(String chatId, Message message) async {
//     try {
//       final messageJson = jsonEncode(message.toJson());

//       final response = await dio.post(
//         '${AppUrls.baseUrl}${AppUrls.createMessage}',
//         data: messageJson,
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//         ),
//       );

//       if (response.statusCode == 200) {
//         AppLogger.info('Message sent successfully', tag: 'CHAT_SERVICE');
//       } else {
//         AppLogger.error(
//           'Error sending message, Status Code: ${response.statusCode}',
//           tag: 'CHAT_SERVICE',
//           error: 'Failed to send message',
//         );
//         throw Exception('Failed to send message');
//       }
//     } on DioException catch (e) {
//       AppLogger.error(
//         'Dio error sending message: ${e.message}',
//         tag: 'CHAT_SERVICE',
//         error: 'Failed to send message',
//       );
//       throw Exception('Error sending message: ${e.message}');
//     } catch (e) {
//       AppLogger.error('Unexpected error: $e', tag: 'CHAT_SERVICE', error: 'Failed to send message');
//       throw Exception('Error sending message: $e');
//     }
//   }

//   Future createChat(ChatData chatData) async {}
// }
