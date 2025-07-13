import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';

class ShopByStoreService {
  final Dio _dio = Dio();

  // Fetch shops by store name from the backend using searchTerm and token
  Future<List<dynamic>> getShopsByStoreName(String token, String searchTerm) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getShopsByProvince}?searchTerm=$searchTerm',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add Bearer token for authentication
          },
        ),
      );

      // Check if the response is successful
      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['data'] is Map &&
          response.data['data']['result'] is List) {
        return response.data['data']['result']; // Return the list of shops
      } else {
        return []; // Return an empty list if something goes wrong
      }
    } catch (e) {
      print('Error fetching shops by store name: $e');
      return []; // Return an empty list if there's an error
    }
  }
}

