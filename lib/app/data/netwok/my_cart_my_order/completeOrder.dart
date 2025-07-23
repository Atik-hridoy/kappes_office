// Path: lib/services/completed_order_service.dart
import 'package:canuck_mall/app/model/get_my_order_model.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:dio/dio.dart';

/// Service class for handling completed order operations
class CompletedOrderService {
  final Dio _dio;

  CompletedOrderService() : _dio = Dio() {
    _dio.options.baseUrl = AppUrls.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // Add LogInterceptor for debugging (optional)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print(obj),
      ),
    );
  }

  /// Fetches completed orders for the current user
  /// Returns orders that are delivered, refunded, returned, or cancelled
  Future<GetMyOrder> getCompletedOrders({
    int page = 1,
    int limit = 10,
    String? authToken,
  }) async {
    try {
      if (authToken != null) {
        _dio.options.headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await _dio.get(
        AppUrls.myOrders,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final orderResponse = GetMyOrder.fromJson(response.data);
        // Client-side filtering for completed orders
        final List<Order> completedOrders = orderResponse.data.result
            .where((order) => _isCompletedOrder(order))
            .toList();

        final updatedMeta = Meta(
          total: completedOrders.length,
          limit: orderResponse.data.meta.limit,
          page: orderResponse.data.meta.page,
          totalPage: (completedOrders.length / orderResponse.data.meta.limit).ceil(),
        );

        return GetMyOrder(
          success: orderResponse.success,
          message: orderResponse.message.isNotEmpty
              ? orderResponse.message
              : 'Completed orders retrieved successfully',
          data: OrderData(
            meta: updatedMeta,
            result: completedOrders,
          ),
          errorMessages: orderResponse.errorMessages,
          statusCode: orderResponse.statusCode,
        );
      } else {
        return _createErrorResponse(
          'Failed to fetch orders: Invalid response',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return _createErrorResponse(
        'Unexpected error occurred: ${e.toString()}',
        500,
      );
    }
  }

  /// Checks if an order is considered completed
  bool _isCompletedOrder(Order order) {
    final status = order.status.toLowerCase().trim();
    const completedStatuses = [
      'delivered',
      'cancelled',
      'refunded',
      'returned',
    ];
    return completedStatuses.contains(status);
  }

  /// Handles Dio exceptions and returns appropriate error response
  GetMyOrder _handleDioException(DioException e) {
    String errorMessage;
    int statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout. Please check your internet connection.';
        statusCode = 408;
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Request timeout. Please try again.';
        statusCode = 408;
        break;
      case DioExceptionType.badResponse:
        statusCode = e.response?.statusCode ?? 500;
        errorMessage = 'Server error: ${e.response?.data?['message'] ?? 'Unknown error'}';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled.';
        statusCode = 499;
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Network error. Please check your connection.';
        statusCode = 500;
        break;
      default:
        errorMessage = 'An unexpected error occurred.';
        statusCode = 500;
    }

    return _createErrorResponse(errorMessage, statusCode);
  }

  /// Creates an error response with the GetMyOrder structure
  GetMyOrder _createErrorResponse(String message, int statusCode) {
    return GetMyOrder(
      success: false,
      message: message,
      data: OrderData(
        meta: Meta(
          total: 0,
          limit: 10,
          page: 1,
          totalPage: 0,
        ),
        result: [],
      ),
      errorMessages: [message],
      statusCode: statusCode,
    );
  }

  void dispose() {
    _dio.close();
  }
}
