import 'package:dio/dio.dart';

import '../../../constants/app_urls.dart';
 // Import the AppUrls class

class ShopByProvinceService {
  final Dio _dio = Dio();

  // Fetch shops by province from the backend
  Future<Map<String, dynamic>> getShopsByProvince(String token) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getShopsByProvince}', // Backend endpoint for shops by province
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add Bearer token for authentication
          },
        ),
      );

      // Return the full response map
      return response.data;
    } catch (e) {
      print('Error fetching shops by province: $e');
      return {};
    }
  }
}
