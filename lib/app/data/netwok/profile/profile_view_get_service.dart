import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileViewGetService {
  final String baseUrl;
  final String? token;

  ProfileViewGetService({required this.baseUrl, this.token});

  Future<Map<String, dynamic>> getProfileData() async {
    try {
      final url = Uri.parse('$baseUrl/api/v1/users/profile');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Profile API error: $e');
    }
  }
}
