import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart'; // AppLogger import

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

      // Add fields to form data
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
      AppLogger.info('📦 Sending PATCH request to: $url');
      AppLogger.info('🔐 Token: Bearer $token');
      for (var e in formData.fields) {
        AppLogger.info('🔹 ${e.key}: ${e.value}');
      }
      if (imageFile != null) {
        AppLogger.info('🖼️ Image attached: ${imageFile.path}');
      }

      // Make the PATCH request with proper headers
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

      // Log response details
      AppLogger.info('📥 Response Status: ${response.statusCode}');
      AppLogger.info('📥 Response Headers: ${response.headers}');
      AppLogger.info('📥 Response Data: ${response.data}');

      // Handle response based on status code
      if (response.statusCode == 200) {
        if (response.data is Map && response.data['success'] == true) {
          AppLogger.info('✅ Profile updated successfully');
          return true;
        }
        AppLogger.warning('⚠️ Unexpected response format: ${response.data}');
        return false;
      } else {
        AppLogger.error(
          '❌ Server responded with status: ${response.statusCode}',
          tag: 'EditInformationViewService',
          error: 'Server responded with status: ${response.statusCode}',
        );
        AppLogger.error('❌ Response: ${response.data}', tag: 'EditInformationViewService', error: 'Response: ${response.data}');
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        AppLogger.error(
          '❌ DioException occurred: ${e.response?.data ?? e.message}',
          tag: 'EditInformationViewService',
          error: 'DioException occurred: ${e.response?.data ?? e.message}',
        );
      } else {
        AppLogger.error('❌ Unexpected error: $e', tag: 'EditInformationViewService', error: 'Unexpected error: $e');
      }
      return false;
    }
  }
}
