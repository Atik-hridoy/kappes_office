import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';
 // Import the AppUrls class

class TradesServicesService {
  final Dio _dio = Dio();

  // Fetch trades and services from the backend
  Future<List<dynamic>> getTradesAndServices(String token) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.tradeNService}', // Backend endpoint for trades and services
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add Bearer token for authentication
          },
        ),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] ?? []; // Return the list of trades and services
      } else {
        return []; // Return an empty list if something goes wrong
      }
    } catch (e) {
      print('Error fetching trades and services: $e');
      return []; // Return an empty list if there's an error
    }
  }
}
