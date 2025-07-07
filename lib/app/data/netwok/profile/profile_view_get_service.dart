import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class ProfileService {
  final dio = Dio();
  Future<Map<String, dynamic>> getProfileData({required String email}) async {
    final token = LocalStorage.token;

    if (token.isEmpty) {
      throw Exception("Auth token not found");
    }

    final url = Uri.parse(AppUrls.profile);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    //final body = jsonEncode({'email': email});

    final response = await dio.get(
      AppUrls.profile,
      options: Options(
        headers: headers,
      ),
      queryParameters: {'email': email},
    );
    
    print("=====================>>>   profile response: ${response.data}");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.data);

      if (result['success'] == true && result['data'] != null) {
        return result['data'];
      } else {
        throw Exception(result['message'] ?? 'Failed to get profile');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
