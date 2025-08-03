import 'package:canuck_mall/app/model/get_message.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';

class MessageService {
  // Base URL for the API
  final Dio dio;

  static const String baseUrl = 'http://10.10.7.112:7000/api/v1';

  MessageService({Dio? dio}) : dio = dio ?? Dio();

  // Fetch messages from the API, now including a userId

  Future<MessageResponse?> fetchMessages(
    String userId,
    int page,
    int limit,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/message/chat/$userId',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        // Parse and return the response data
        return MessageResponse.fromJson(response.data);
      } else {
        // Handle non-200 responses
        AppLogger.error('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle errors like no internet connection or timeout
      AppLogger.error('Error occurred: $e');
      return null;
    }
  }
}
