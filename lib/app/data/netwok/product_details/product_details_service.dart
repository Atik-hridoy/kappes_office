import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ProductDetailsService {
  final Dio _dio = Dio();

  /// Fetches product by its ID from backend
  Future<Map<String, dynamic>> getProductById(String id) async {
    final url = '${AppUrls.baseUrl}/product/$id';
    print('📤 [GET] $url');

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        print('✅ Product data fetched: ${data['name']}');
        return Map<String, dynamic>.from(data);
      } else {
        final errorMsg = response.data['message'] ?? 'Unknown error occurred';
        print('⚠️ API Error: $errorMsg');
        throw Exception('Failed to fetch product: $errorMsg');
      }
    } on DioException catch (dioErr) {
      print('❌ DioException: ${dioErr.message}');
      throw Exception('Network error: ${dioErr.message}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Something went wrong: $e');
    }
  }
}
