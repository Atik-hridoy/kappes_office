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
            // Add your token refresh logic here if needed
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<OrderResponse> createOrder(OrderRequest request) async {
    try {
      final response = await _dio.post(
        AppUrls.createOrder,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return OrderResponse.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleError(e.response);
    } catch (e) {
      throw ApiException(message: 'Unknown error occurred');
    }
  }

  ApiException _handleError(Response? response) {
    final statusCode = response?.statusCode ?? 500;
    final errorData = response?.data as Map<String, dynamic>?;

    return ApiException(
      code: statusCode,
      message: errorData?['message'] ?? 'Failed to create order',
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
