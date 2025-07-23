import 'package:canuck_mall/app/model/get_my_order_model.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:dio/dio.dart';

/// Service class for handling ongoing order operations
class GetOngoingOrderService {
  final Dio _dio;
  
  GetOngoingOrderService() : _dio = Dio() {
    _dio.options.baseUrl = AppUrls.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add interceptor for debugging (optional)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print(obj),
      ),
    );
  }

  /// Fetches ongoing orders for the current user
  /// Returns orders that are not delivered or cancelled
  Future<GetMyOrder> getOngoingOrders({
    int page = 1,
    int limit = 10,
    String? authToken,
  }) async {
    try {
      // Add authorization header if token is provided
      if (authToken != null) {
        _dio.options.headers['Authorization'] = 'Bearer $authToken';
      }

      // Make request to get user orders
      final response = await _dio.get(
        AppUrls.myOrders,
        queryParameters: {
          'page': page,
          'limit': limit,
          'status': 'ongoing', // Filter for ongoing orders at API level if supported
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final orderResponse = GetMyOrder.fromJson(response.data);
        
        // Additional client-side filtering for ongoing orders
        final List<Order> ongoingOrders = orderResponse.data.result
            .where((order) => _isOngoingOrder(order))
            .toList();

        // Create updated meta information
        final updatedMeta = Meta(
          total: ongoingOrders.length,
          limit: orderResponse.data.meta.limit,
          page: orderResponse.data.meta.page,
          totalPage: (ongoingOrders.length / orderResponse.data.meta.limit).ceil(),
        );

        // Return filtered ongoing orders
        return GetMyOrder(
          success: orderResponse.success,
          message: orderResponse.message.isNotEmpty 
              ? orderResponse.message 
              : 'Ongoing orders retrieved successfully',
          data: OrderData(
            meta: updatedMeta,
            result: ongoingOrders,
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

  /// Checks if an order is considered ongoing
  bool _isOngoingOrder(Order order) {
    final status = order.status.toLowerCase().trim();
    
    // Define ongoing statuses (not delivered, cancelled, or refunded)
    const ongoingStatuses = [
      'pending',
      'confirmed',
      'processing',
      'shipped',
      'out_for_delivery',
      'ready_for_pickup',
    ];
    
    const completedStatuses = [
      'delivered',
      'cancelled',
      'refunded',
      'returned',
    ];
    
    // If status is explicitly in ongoing list, it's ongoing
    if (ongoingStatuses.contains(status)) {
      return true;
    }
    
    // If status is explicitly in completed list, it's not ongoing
    if (completedStatuses.contains(status)) {
      return false;
    }
    
    // For unknown statuses, consider them ongoing if payment is not completed
    // or if the order was created recently (within last 30 days)
    final isRecentOrder = DateTime.now().difference(order.createdAt).inDays <= 30;
    final isPaymentPending = order.paymentStatus.toLowerCase() != 'completed';
    
    return isRecentOrder || isPaymentPending;
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

  /// Dispose method to clean up resources
  void dispose() {
    _dio.close();
  }
}
