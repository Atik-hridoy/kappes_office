import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_message.dart'; // Import the model for the response
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';

class MessageService {
  // Dio instance for making API calls
  final Dio dio;

  // Base URL for the API
  static const String baseUrl = AppUrls.baseUrl;

  MessageService({Dio? dio}) : dio = dio ?? Dio() {
    // Add interceptor to include auth token in requests
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get the token from storage
          final token = LocalStorage.token;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Handle 401 Unauthorized error (e.g., token expired)
            // You might want to refresh the token or log the user out
            AppLogger.error('Authentication error: ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Fetch messages from the API with pagination using chatId
  Future<GetMessageResponse?> fetchMessages(
    String chatId, // Changed from userId to chatId
    int page,
    int limit,
  ) async {
    try {
      // Log the request details
      AppLogger.info(
        'Fetching messages',
        context: {
          'chatId': chatId,
          'page': page,
          'limit': limit,
          'endpoint': AppUrls.getChatForUser,
        },
      );

      final response = await dio.get(           
        AppUrls.getChatForUser,
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500, // Don't throw for 4xx errors
        ),
      );

      AppLogger.info(
        'API Response',
        context: {
          'statusCode': response.statusCode,
          'data': response.data,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response data into GetMessageResponse model
        return GetMessageResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        // Handle 400 Bad Request specifically
        AppLogger.error(
          'Bad Request',
          context: {
            'statusCode': response.statusCode,
            'response': response.data,
            'request': {
              'url': AppUrls.getChatForUser,
              'queryParams': {'page': page, 'limit': limit},
            },
          },
        );
        // You might want to throw a specific exception or return a custom error response
        throw Exception('Invalid request: ${response.data}');
      } else {
        // Log error if response status code is not 200
        AppLogger.error(
          'API Error',
          context: {
            'statusCode': response.statusCode,
            'response': response.data,
          },
        );
        return null;
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      AppLogger.error(
        'Dio Error',
        context: {
          'type': e.type,
          'message': e.message,
          'response': e.response?.data,
          'request': e.requestOptions.uri.toString(),
        },
      );
      rethrow;
    } catch (e, stackTrace) {
      // Handle other unexpected exceptions
      AppLogger.error(
        'Unexpected Error',
        context: {
          'error': e.toString(),
          'stackTrace': stackTrace.toString(),
        },
      );
      rethrow;
    }
  }
}
