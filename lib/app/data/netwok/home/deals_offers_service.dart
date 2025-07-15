import 'package:dio/dio.dart';

import '../../../constants/app_urls.dart';
 // Import the AppUrls class

class DealsAndOffersService {
  final Dio _dio = Dio();

  // Fetch the deals and offers from the backend
  Future<List<dynamic>> getDealsAndOffers(String token) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.offered}', // Backend endpoint for deals and offers
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add Bearer token for authentication
          },
        ),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && response.data['success'] == true) {
        print('Deals and offers fetched successfully');
        print('Response data: ${response.data}');
        return response.data['data']['result'] ?? []; // Return the list of deals and offers
      } else {
        print('Error: ${response.statusCode} - ${response.data}');
        return []; // Return an empty list if something goes wrong
      }
    } catch (e) {
      print('Error fetching deals and offers: $e');
      return []; // Return an empty list if there's an error
    }
  }
}
