import 'package:dio/dio.dart';

import '../../../constants/app_urls.dart';
// Import the AppUrls class

class TermsConditionsService {
  final Dio _dio = Dio();

  // Fetch the terms and conditions from the backend
  Future<String> getTermsConditions(String token) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getTerms}', // Backend endpoint for terms of service
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add Bearer token for authentication
          },
        ),
      );

      // Handle the response
      if (response.statusCode == 200 && response.data['success'] == true) {
        // Extract and return the HTML content of terms and conditions
        return response.data['data'] ?? 'Terms and conditions not available';
      } else {
        return 'Failed to load terms and conditions';
      }
    } catch (e) {
      // Handle any exceptions and print the error
      print('Error fetching terms and conditions: $e');
      return 'An error occurred: ${e.toString()}';
    }
  }
}
