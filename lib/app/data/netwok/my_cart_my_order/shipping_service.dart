import 'package:canuck_mall/app/model/sheeping_model.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class ShippingService {
  final Dio _dio = Dio();

  Future<ShippingDetails> getShippingDetails() async {
    final url = '${AppUrls.baseUrl}${AppUrls.shipping}';
    final token = await LocalStorage.getString('token');

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
        return ShippingDetails.fromJson(response.data);
      } else {
        throw Exception('Failed to load shipping details');
      }
    } catch (e) {
      throw Exception('Failed to fetch shipping details: $e');
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