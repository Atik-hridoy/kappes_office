import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class StoreService {
  final Dio _dio = Dio();

  /// Fetch shop details by Shop ID
  Future<Map<String, dynamic>> fetchShopDetails(String shopId) async {
    try {
      print('[StoreService] Fetching details for Shop ID: $shopId');
      final response = await _dio.get('${AppUrls.baseUrl}/shop/$shopId');
      print('[StoreService] Shop details response: ${response.data}');

      if (response.statusCode == 200 && response.data['success']) {
        print('[StoreService] Successfully fetched shop details');
        return response.data;  // Return raw JSON data
      } else {
        print('[StoreService] Failed to fetch shop details');
        throw Exception('Failed to fetch shop details');
      }
    } catch (e) {
      print('[StoreService] Error fetching shop details: $e');
      throw Exception('Error fetching shop details');
    }
  }

  /// Fetch products by Shop ID
  Future<List<dynamic>> fetchProductsByShopId(String shopId) async {
    try {
      print('[StoreService] Fetching products for Shop ID: $shopId');
      final response = await _dio.get('${AppUrls.baseUrl}/shop/products/$shopId');
      print('[StoreService] Products response: ${response.data}');

      if (response.statusCode == 200 && response.data['success']) {
        print('[StoreService] Successfully fetched products');
        final products = response.data['data']['products'];
        // Fetch images for each product and add as 'imageUrls' field
        if (products is List) {
          for (var product in products) {
            if (product is Map && product['images'] != null && product['images'] is List) {
              product['imageUrls'] = (product['images'] as List)
                  .map((img) => img.toString())
                  .toList();
            } else {
              product['imageUrls'] = [];
            }
          }
        }
        return products;
      } else {
        print('[StoreService] Failed to fetch products');
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('[StoreService] Error fetching products: $e');
      throw Exception('Error fetching products');
    }
  }

  /// Fetch image url for a given path (shop logo or cover)
  Future<String> fetchImage(String? path) async {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${AppUrls.baseUrl}$path';
  }
}
