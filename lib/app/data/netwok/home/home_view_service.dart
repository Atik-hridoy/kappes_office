import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

import '../../../model/recomended_item_model.dart';
// Import your Item model here

class HomeViewService {
  final Dio _dio = Dio();

  // Fetch recommended products from the API
  Future<List<Item>> fetchRecommendedProducts() async {
    final String url = '${AppUrls.baseUrl}${AppUrls.recommendedProducts}';
    print('📤 [GET] Request: $url'); // Debugging print for the API request

    try {
      final response = await _dio.get(url);
      print(
        '✅ [GET] Response: ${response.data}',
      ); // Debugging print for the API response

      if (response.statusCode == 200 && response.data['success'] == true) {
        final rawData = response.data['data'];
        final iterable = rawData is List
            ? rawData
            : (rawData is Map<String, dynamic> && rawData['result'] is Iterable
                ? rawData['result'] as Iterable
                : const []);

        if (iterable.isEmpty) {
          throw Exception('Recommended products response missing result list');
        }

        return iterable
            .map((product) => Item.fromJson(Map<String, dynamic>.from(product)))
            .toList();
      } else {
        final errorMsg = response.data['message'] ?? 'Unknown error';
        print('⚠️ API Error: $errorMsg'); // Debugging print for errors
        throw Exception('Failed to fetch recommended products: $errorMsg');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Something went wrong: $e');
    }
  }
}
