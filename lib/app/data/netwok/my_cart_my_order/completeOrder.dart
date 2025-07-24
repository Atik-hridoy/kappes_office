import 'package:canuck_mall/app/model/get_my_order.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart'
    hide GetMyOrder, Order;
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

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
    // _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));
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
        AppUrls.getOrders,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        final GetMyOrder orderResponse = GetMyOrder.fromJson(response.data);
        // Filter for completed statuses
        final List<Order> completedOrders =
            orderResponse.data.result.where((order) {
              final status = order.status.toLowerCase();
              return status == 'delivered' ||
                  status == 'refunded' ||
                  status == 'returned' ||
                  status == 'cancelled';
            }).toList();

        // Return a new GetMyOrder object containing only completed orders
        return GetMyOrder(
          success: orderResponse.success,
          message: orderResponse.message,
          data: Data(meta: orderResponse.data.meta, result: completedOrders),
          errorMessages: orderResponse.errorMessages,
          statusCode: orderResponse.statusCode,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load orders: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error or request setup issue: ${e.type}';
      if (e.response != null) {
        errorMessage +=
            ' Status: ${e.response!.statusCode}. Data: ${e.response!.data}';
      } else if (e.message != null) {
        errorMessage += ' Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
