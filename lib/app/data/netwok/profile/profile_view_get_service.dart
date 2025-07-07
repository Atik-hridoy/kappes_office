import 'dart:convert';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:canuck_mall/app/data/local/storage_service.dart';

class ProfileService {
  Future<Map<String, dynamic>> getProfileData() async {
    final token = LocalStorage.token;

    if (token.isEmpty) {
      throw Exception("Auth token not found");
    }

    final url = Uri.parse('${AppUrls.baseUrl}${AppUrls.profile}');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body['success'] == true && body['data'] != null) {
        return body['data'];
      } else {
        throw Exception(body['message'] ?? 'Failed to get profile');
      }
    } else {
      throw Exception('Server Error: ${response.statusCode} - ${response.body}');
    }
  }
}
