import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class EditInformationViewService {
  final Dio _dio = Dio();

  Future<bool> updateProfile(
    String fullName,
    String email,
    String phone,
    String address,
    File? imageFile,
  ) async {
    final String url = '${AppUrls.baseUrl}${AppUrls.profile}';
    final token = LocalStorage.token;

    try {
      // Create FormData instance directly
      final formData = FormData();

      // Add fields only if they are not empty after trimming
      void addIfNotEmpty(String key, String value) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          formData.fields.add(MapEntry(key, trimmed));
        }
      }

      // // Add fields with proper null/empty checks
      // addIfNotEmpty('full_name', fullName);
      // addIfNotEmpty('email', email);
      // addIfNotEmpty('phone', phone);
      // addIfNotEmpty('address', address);

      var body = {
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "address": address,
      };

      formData.fields.add(MapEntry("data", jsonEncode(body)));

      // Add image file if present
      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }

      // Log the request details
      print('📦 Sending PATCH request to: $url');
      print('🔐 Token: Bearer $token');
      formData.fields.forEach((e) => print('🔹 ${e.key}: ${e.value}'));
      if (imageFile != null) {
        print('🖼️ Image attached: ${imageFile.path}');
      }

      // Make the request with proper headers
      final response = await _dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          validateStatus:
              (status) => status! < 500, // Accept all status codes < 500
        ),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Headers: ${response.headers}');
      print('📥 Response Data: ${response.data}');

      // Handle response based on status code
      if (response.statusCode == 200) {
        if (response.data is Map && response.data['success'] == true) {
          print('✅ Profile updated successfully');
          return true;
        }
        print('⚠️ Unexpected response format: ${response.data}');
        return false;
      } else {
        print('❌ Server responded with status: ${response.statusCode}');
        print('❌ Response: ${response.data}');
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        print('❌ DioException occurred: ${e.response?.data ?? e.message}');
      } else {
        print('❌ Unexpected error: $e');
      }
      return false;
    }
  }
}
