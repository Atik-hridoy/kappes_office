import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class ProfileService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getProfileData({required String email}) async {
    try {
      final token = LocalStorage.token;
      print("=====================>>>   Using token: ${token.isNotEmpty ? 'Token found' : 'No token found'}");

      if (token.isEmpty) {
        throw Exception("Authentication token not found. Please log in again.");
      }

      final response = await _dio.get(
        AppUrls.profile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500, // Accept all status codes below 500
        ),
        queryParameters: {'email': email},
      );

      print("=====================>>>   Profile API Response Status: ${response.statusCode}");
      print("=====================>>>   Profile API Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Dio already parses JSON responses by default
        final Map<String, dynamic> responseData = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'data': responseData['data'] ?? {},
            'message': responseData['message'] ?? 'Profile data retrieved successfully'
          };
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch profile data');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please log in again.');
      } else {
        final errorData = response.data is String ? jsonDecode(response.data) : response.data;
        throw Exception(errorData['message'] ?? 'Failed to load profile data. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=====================>>>   Dio Error: ${e.message}");
      print("=====================>>>   Dio Error Type: ${e.type}");
      print("=====================>>>   Dio Error Response: ${e.response?.data}");

      if (e.response?.statusCode == 401) {
        throw Exception('Your session has expired. Please log in again.');
      }

      throw Exception(e.response?.data?['message'] ?? 'Network error occurred. Please try again.');
    } catch (e) {
      print("=====================>>>   Unexpected Error: $e");
      throw Exception('An unexpected error occurred: $e');
    }
  }
}