import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class StoreService {
  final Dio _dio = Dio();

  /// Fetch shop details by Shop ID
  Future<Map<String, dynamic>> fetchShopDetails(String shopId) async {
    try {
      AppLogger.debug('Fetching details for Shop ID: $shopId', tag: 'STORE_SERVICE');
      final response = await _dio.get('${AppUrls.baseUrl}/shop/$shopId');
      AppLogger.debug('Shop details response: ${response.data}', tag: 'STORE_SERVICE');

      if (response.statusCode == 200 && response.data['success']) {
        AppLogger.info('Successfully fetched shop details', tag: 'STORE_SERVICE');
        return response.data;  // Return raw JSON data
      } else {
        AppLogger.error('Failed to fetch shop details', tag: 'STORE_SERVICE');
        throw Exception('Failed to fetch shop details');
      }
    } catch (e) {
      AppLogger.error('Error fetching shop details: $e', tag: 'STORE_SERVICE');
      throw Exception('Error fetching shop details');
    }
  }

  /// Fetch products by Shop ID
  Future<List<dynamic>> fetchProductsByShopId(String shopId) async {
    try {
      AppLogger.debug('Fetching products for Shop ID: $shopId', tag: 'STORE_SERVICE');
      final response = await _dio.get('${AppUrls.baseUrl}/shop/products/$shopId');
      AppLogger.debug('Products response: ${response.data}', tag: 'STORE_SERVICE');

      if (response.statusCode == 200 && response.data['success']) {
        AppLogger.info('Successfully fetched products', tag: 'STORE_SERVICE');
        return response.data['data']['products'];  // Return product list
      } else {
        AppLogger.error('Failed to fetch products', tag: 'STORE_SERVICE');
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      AppLogger.error('Error fetching products: $e', tag: 'STORE_SERVICE');
      throw Exception('Error fetching products');
    }
  }
}
