import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class TrendingProductsService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> getTrendingProducts({
    required String token,
  }) async {
    final url = '${AppUrls.baseUrl}${AppUrls.trendingProduct}';

    print('📤 Sending GET to: $url');

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data']['result'];
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('❗ Dio error: $e');
      throw Exception('Dio error: $e');
    }
  }
}
