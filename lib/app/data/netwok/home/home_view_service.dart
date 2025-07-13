import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

import '../../../model/item_model.dart';
 // Import your Item model here

class HomeViewService {
  final Dio _dio = Dio();

  // Fetch recommended products from the API
  Future<List<Item>> fetchRecommendedProducts() async {
    final String url = '${AppUrls.baseUrl}${AppUrls.recommendedProducts}';
    print('📤 [GET] Request: $url'); // Debugging print for the API request

    try {
      final response = await _dio.get(url);
      print('✅ [GET] Response: ${response.data}'); // Debugging print for the API response

      if (response.statusCode == 200 && response.data['success'] == true) {
        List<Item> items = [];
        for (var product in response.data['data']) {
          items.add(Item.fromJson(product)); // Use the new Item model
        }
        return items;
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
