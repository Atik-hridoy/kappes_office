import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';



class DataPrivacyService {
  final Dio _dio = Dio();

  // Fetch the privacy policy from the backend
  Future<String> getPrivacyPolicy(String token) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getPrivacy}', // Backend endpoint
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add Bearer token for authentication
          },
        ),
      );

      // Handle the response
      if (response.statusCode == 200 && response.data['success'] == true) {
        // Extract and return the privacy policy HTML content
        return response.data['data'] ?? 'Privacy policy not available';
      } else {
        return 'Failed to load privacy policy';
      }
    } catch (e) {
      // Handle any exceptions and print the error
      return 'An error occurred: ${e.toString()}';
    }
  }
}
