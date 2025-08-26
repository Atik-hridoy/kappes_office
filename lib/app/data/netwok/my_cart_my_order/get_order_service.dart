import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class GetOrderService {
  final Dio _dio;

  GetOrderService() : _dio = Dio() {
    _dio.options.baseUrl = AppUrls.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // Optional: Add logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => AppLogger.debug(obj, tag: 'GetOrderService', error: obj),
      ),
    );
  }

  /// Fetches orders (all, ongoing, or completed) for the current user
  /// [status] can be 'ongoing', 'completed', or null for all
  /// Returns [GetMyOrder]
  Future<OrderResponseModel> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
    String? authToken,
  }) async {
    try {
      // Ensure token is loaded
      if (LocalStorage.token.isEmpty) {
        await LocalStorage.getAllPrefData();
      }
      if (LocalStorage.token.isEmpty) {
        throw Exception('No auth token found. Please log in.');
      }
      _dio.options.headers['Authorization'] = 'Bearer ${LocalStorage.token}';

      final Map<String, dynamic> params = {'page': page, 'limit': limit};
      if (status != null && status.isNotEmpty) {
        params['status'] = status;
      }
      final response = await _dio.get(
        AppUrls.getOrders,
        queryParameters: params,
      );
      AppLogger.debug('[GetOrderService] Raw response: ${response.data}', tag: 'GetOrderService', error: 'Raw response: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        return OrderResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  void dispose() {
    _dio.close();
  }
}