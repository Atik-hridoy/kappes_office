
import 'package:canuck_mall/app/model/sheeping_model.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class ShippingService {
  final Dio _dio = Dio();

  Future<ShippingDetails> getShippingDetails() async {
    final url = '${AppUrls.baseUrl}${AppUrls.shipping}';
    final token = await LocalStorage.getString('token');
    print('🔍 [ShippingService] Fetching shipping details from: $url');
    print('🔑 Token available: ${token.isNotEmpty}');

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        AppLogger.debug('✅ [ShippingService] Successfully fetched shipping details', tag: 'SHIPPING_SERVICE', error: '✅ [ShippingService] Successfully fetched shipping details');
        AppLogger.debug('📦 Response data: ${response.data}', tag: 'SHIPPING_SERVICE', error: '📦 Response data: ${response.data}');
        final details = ShippingDetails.fromJson(response.data);
        AppLogger.debug('📊 Parsed shipping data: ${details.data.toJson()}', tag: 'SHIPPING_SERVICE', error: '📊 Parsed shipping data: ${details.data.toJson()}');
        return details;
      } else {
        final errorMsg = '❌ [ShippingService] Failed to load shipping details. Status: ${response.statusCode}';
        AppLogger.error(errorMsg, tag: 'SHIPPING_SERVICE', error: errorMsg);
        AppLogger.debug('Response data: ${response.data}', tag: 'SHIPPING_SERVICE', error: 'Response data: ${response.data}');
        throw Exception(errorMsg);
      }
    } catch (e) {
      AppLogger.error('⚠️ [ShippingService] Error fetching shipping details: $e', tag: 'SHIPPING_SERVICE', error: '⚠️ [ShippingService] Error fetching shipping details: $e');
      AppLogger.error('🔄 Falling back to default shipping details', tag: 'SHIPPING_SERVICE', error: '🔄 Falling back to default shipping details');
      // Fallback to default shipping details if API fails
      return ShippingDetails(
        success: true,
        message: 'Using default shipping details',
        data: ShippingData(
          freeShipping: ShippingType(area: ['free', 'pickup', 'store'], cost: 0),
          centralShipping: ShippingType(
            area: ['central', 'downtown', 'main city'],
            cost: 6, // $5.99 rounded to nearest integer
          ),
          countryShipping: ShippingType(
            area: ['north', 'south', 'east', 'west', 'suburb', 'outskirts'],
            cost: 10, // $9.99 rounded to nearest integer
          ),
          worldWideShipping: ShippingType(area: null, cost: 20), // $19.99 rounded
        ),
      );
    }
  }

  // Add any additional shipping-related methods here if needed

  Future<Map<String, dynamic>> updateShippingDetails(ShippingData shippingData) async {
    final url = '${AppUrls.baseUrl}${AppUrls.shipping}';
    final token = await LocalStorage.getString('token');

    try {
      final response = await _dio.put(
        url,
        data: shippingData.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data is Map<String, dynamic> ? response.data : {};
      } else {
        throw Exception('Failed to update shipping details');
      }
    } catch (e) {
      throw Exception('Failed to update shipping details: $e');
    }
  }
}