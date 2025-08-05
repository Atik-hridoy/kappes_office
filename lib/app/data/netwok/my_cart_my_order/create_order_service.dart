import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:dio/dio.dart';

class OrderService {
  final Dio _dio;

  OrderService(String authToken) : _dio = Dio() {
    // Configure Dio instance
    _dio.options.baseUrl = AppUrls.baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Handle 401 unauthorized errors
          if (error.response?.statusCode == 401) {
            // Token refresh logic could go here, for example:
            // refreshToken();
            print('Unauthorized - Token expired or invalid');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<OrderResponse> createOrder(OrderRequest request) async {
    try {
      print(
        'OrderService: Sending order request: ${request.toJson()}',
      );
      print(
        'OrderService: Posting to URL: \x1B[32m${_dio.options.baseUrl}${AppUrls.createOrder}\x1B[0m',
      );
      final response = await _dio.post(
        AppUrls.createOrder,
        data: request.toJson(),
      );

      // Check for a successful status code (201 indicates resource creation)
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("==================>> create order success $response.statusCode");
        return OrderResponse.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      // Handle Dio specific errors like connectivity issues, etc.
      print('DioException: ${e.message}');
      throw _handleError(e.response);
    } catch (e) {
      // Handle other types of errors
      print('Unexpected error: $e');
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  ApiException _handleError(Response? response) {
    final statusCode = response?.statusCode ?? 500;
    final errorData = response?.data as Map<String, dynamic>?;

    // You can log the response for debugging purposes
    print('Error response: ${errorData ?? 'No error data available'}');

    return ApiException(
      code: statusCode,
      message:
          errorData?['message'] ??
          'An error occurred while processing your request.',
      details: errorData,
    );
  }
}

class ApiException implements Exception {
  final int code;
  final String message;
  final dynamic details;

  ApiException({required this.message, this.code = 500, this.details});

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}
