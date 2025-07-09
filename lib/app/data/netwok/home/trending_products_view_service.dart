import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class TrendingProductsViewService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getTrendingProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = LocalStorage.token;
      
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        validateStatus: (status) => status! < 500, // Accept all status codes below 500
      );

      final params = {
        'page': page,
        'limit': limit,
        'sort': '-purchaseCount', // Sort by purchase count in descending order
      };

      print('🌐 Fetching trending products...');
      print('📡 URL: ${AppUrls.baseUrl}${AppUrls.trendingProducts}');
      print('🔍 Params: $params');
      
      final response = await _dio.get<Map<String, dynamic>>(
        '${AppUrls.baseUrl}${AppUrls.trendingProducts}',
        queryParameters: params,
        options: options,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        return response.data ?? {};
      } else {
        final errorData = response.data;
        throw Exception(
          errorData?['message']?.toString() ?? 'Failed to load trending products. Status: ${response.statusCode}'
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response != null) {
        print('❌ Response data: ${e.response?.data}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response headers: ${e.response?.headers}');
      } else {
        print('❌ Error request: ${e.requestOptions.uri}');
        print('❌ Error message: ${e.message}');
      }
      rethrow;
    } catch (e) {
      print('❌ Unexpected error in TrendingProductsViewService: $e');
      rethrow;
    }
  }
}