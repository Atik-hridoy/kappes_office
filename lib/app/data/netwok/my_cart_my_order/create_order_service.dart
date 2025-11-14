import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
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
            AppLogger.debug('Unauthorized - Token expired or invalid', tag: 'OrderService', error: 'Unauthorized - Token expired or invalid');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<OrderResponse> createOrder(OrderRequest request) async {
    try {
      final Map<String, dynamic> payload = {
        'shop': request.shop,
        'products': request.products
            .map(
              (p) => {
                'product': p.product,
                'variant': p.variant,
                'quantity': p.quantity,
              },
            )
            .toList(),
        'deliveryOptions': request.deliveryOptions,
        'shippingAddress': request.shippingAddress,
        'paymentMethod': request.paymentMethod,
      };

      if (request.coupon != null && request.coupon!.isNotEmpty) {
        payload['coupon'] = request.coupon;
      }

      AppLogger.debug(
        '🚀 [OrderService] REQUEST PAYLOAD: $payload', 
        tag: 'OrderService', 
        error: 'REQUEST PAYLOAD: $payload',
      );
      AppLogger.debug(
        '🌐 [OrderService] POST URL: ${_dio.options.baseUrl}${AppUrls.createOrder}', 
        tag: 'OrderService', 
        error: 'POST URL: ${_dio.options.baseUrl}${AppUrls.createOrder}',
      );
      AppLogger.debug(
        '🔑 [OrderService] HEADERS: ${_dio.options.headers}', 
        tag: 'OrderService', 
        error: 'HEADERS: ${_dio.options.headers}',
      );
      
      final response = await _dio.post(
        AppUrls.createOrder,
        data: payload,
      );

      AppLogger.debug(
        '📥 [OrderService] RAW RESPONSE STATUS: ${response.statusCode}', 
        tag: 'OrderService', 
        error: 'RAW RESPONSE STATUS: ${response.statusCode}',
      );
      AppLogger.debug(
        '📥 [OrderService] RAW RESPONSE DATA: ${response.data}', 
        tag: 'OrderService', 
        error: 'RAW RESPONSE DATA: ${response.data}',
      );

      // Check for a successful status code (201 indicates resource creation)
      if (response.statusCode == 201 || response.statusCode == 200) {
        final orderResponse = OrderResponse.fromJson(response.data);
        AppLogger.debug(
          '✅ [OrderService] PARSED RESPONSE: success=${orderResponse.success}, message=${orderResponse.message}, data.url=${orderResponse.data?.url}', 
          tag: 'OrderService', 
          error: 'PARSED RESPONSE: success=${orderResponse.success}, message=${orderResponse.message}, data.url=${orderResponse.data?.url}',
        );
        return orderResponse;
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      // Handle Dio specific errors like connectivity issues, etc.
      AppLogger.debug('DioException: ${e.message}', tag: 'OrderService', error: 'DioException: ${e.message}');
      throw _handleError(e.response);
    } catch (e) {
      // Handle other types of errors
      AppLogger.debug('Unexpected error: $e', tag: 'OrderService', error: 'Unexpected error: $e');
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  ApiException _handleError(Response? response) {
    final statusCode = response?.statusCode ?? 500;
    final errorData = response?.data as Map<String, dynamic>?;

    // You can log the response for debugging purposes
    AppLogger.debug('Error response: ${errorData ?? 'No error data available'}', tag: 'OrderService', error: 'Error response: ${errorData ?? 'No error data available'}'      );

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