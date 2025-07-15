import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart'; // Ensure you have AppUrls constants for the endpoint

class ShopByTerritoryService {
  final Dio _dio = Dio();

  // Fetch shops by territory using searchTerm and token
  Future<List<dynamic>> getShopsByTerritory(String token, String searchTerm) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.shopByTerritory}?searchTerm=$searchTerm',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Using Bearer token for authentication
          },
        ),
      );

      // Debugging: Check response
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      // Check if the response is successful and contains the expected data
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']['result']; // Return list of shops
      } else {
        print('Error: ${response.statusCode} - ${response.data}');
        return []; // Return empty list if something goes wrong
      }
    } catch (e) {
      print('Error fetching shops by territory: $e');
      return []; // Return empty list if there's an error
    }
  }
}
