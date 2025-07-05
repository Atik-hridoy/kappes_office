import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:canuck_mall/app/constants/app_urls.dart';

class ProfileService {
  static Future<Map<String, dynamic>?> getProfile({required String token}) async {
    final url = Uri.parse('${AppUrls.baseUrl}${AppUrls.profile}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['data']; // returns user data only
      } else {
        print("Profile fetch failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception in getProfile: $e");
      return null;
    }
  }
}
