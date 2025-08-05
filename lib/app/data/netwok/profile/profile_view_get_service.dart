import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class ProfileService {
  final Dio _dio = Dio();

  /// Test network connectivity to the API server
  Future<bool> testConnectivity() async {
    try {
      AppLogger.info(
        "=====================>>>   Testing connectivity to: ${AppUrls.baseUrl}",
      );

      // Use a simple GET request to test connectivity
      final response = await _dio.get(
        AppUrls.baseUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          validateStatus:
              (status) => status! < 500, // Accept any response below 500
        ),
      );

      AppLogger.info(
        "=====================>>>   Connectivity test successful. Status: ${response.statusCode}",
      );
      return true; // If we get any response, connectivity is working
    } catch (e) {
      AppLogger.error(
        "=====================>>>   Connectivity test failed: $e",
      );
      return false;
    }
  }

  /// Test if the API server is accessible
  Future<bool> testApiServer() async {
    try {
      AppLogger.info(
        "=====================>>>   Testing API server accessibility",
      );

      // Test the base URL first
      final baseResponse = await _dio.get(
        AppUrls.baseUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (status) => status! < 500,
        ),
      );

      AppLogger.info(
        "=====================>>>   Base URL test successful. Status: ${baseResponse.statusCode}",
      );

      // Test the profile endpoint specifically
      final token = LocalStorage.token;
      if (token.isNotEmpty) {
        try {
          final profileResponse = await _dio.get(
            '${AppUrls.baseUrl}${AppUrls.profile}',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              validateStatus: (status) => status! < 500,
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

          AppLogger.info(
            "=====================>>>   Profile endpoint test successful. Status: ${profileResponse.statusCode}",
          );
          return true;
        } catch (e) {
          AppLogger.error(
            "=====================>>>   Profile endpoint test failed: $e",
          );
          return false;
        }
      } else {
        AppLogger.warning(
          "=====================>>>   No token available for profile endpoint test",
        );
        return false;
      }
    } catch (e) {
      AppLogger.error("=====================>>>   API server test failed: $e");
      return false;
    }
  }

  /// Update the user's profile image
  Future<String?> updateProfileImage(String filePath) async {
    final token = LocalStorage.token;
    final url = '${AppUrls.baseUrl}${AppUrls.profile}';
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath, filename: 'profile.jpg'),
    });
    try {
      final response = await _dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        // Return the new image URL if present
        final data = response.data['data'];
        if (data != null && data['image'] != null) {
          return data['image'].toString();
        }
        return null;
      } else {
        AppLogger.error('Profile image update failed: ${response.data}');
        return null;
      }
    } catch (e) {
      AppLogger.error('Profile image update failed: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getProfileData({required String email}) async {
    try {
      final token = LocalStorage.token;
      AppLogger.info(
        "=====================>>>   Using token: ${token.isNotEmpty ? 'Token found (${token.substring(0, 10)}...)' : 'No token found'}",
      );

      if (token.isEmpty) {
        throw Exception("Authentication token not found. Please log in again.");
      }

      // Check if we have a valid base URL
      if (AppUrls.baseUrl.isEmpty) {
        throw Exception("Invalid API base URL configuration");
      }

      final String url = '${AppUrls.baseUrl}${AppUrls.profile}';
      AppLogger.info("=====================>>>   Making request to: $url");
      AppLogger.info("=====================>>>   Base URL: ${AppUrls.baseUrl}");
      AppLogger.info(
        "=====================>>>   Profile endpoint: ${AppUrls.profile}",
      );
      AppLogger.info("=====================>>>   Fetching profile data");

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus:
              (status) => status! < 500, // Accept all status codes below 500
          // Add timeout configuration
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
        // Remove queryParameters as the profile endpoint might not expect email parameter
        // queryParameters: {'email': email},
      );

      AppLogger.info(
        "=====================>>>   Profile API Response Status: ${response.statusCode}",
      );
      AppLogger.info(
        "=====================>>>   Profile API Response Data: ${response.data}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Dio already parses JSON responses by default
        final Map<String, dynamic> responseData =
            response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'data': responseData['data'] ?? {},
            'message':
                responseData['message'] ??
                'Profile data retrieved successfully',
          };
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to fetch profile data',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please log in again.');
      } else {
        final errorData =
            response.data is String ? jsonDecode(response.data) : response.data;
        throw Exception(
          errorData['message'] ??
              'Failed to load profile data. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      AppLogger.error("=====================>>>   Dio Error: ${e.message}");
      AppLogger.error("=====================>>>   Dio Error Type: ${e.type}");
      AppLogger.error(
        "=====================>>>   Dio Error Response: ${e.response?.data}",
      );

      // Handle different DioException types
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception(
            'Request timeout. Please check your internet connection and try again.',
          );
        case DioExceptionType.connectionError:
          throw Exception(
            'No internet connection. Please check your network and try again.',
          );
        case DioExceptionType.unknown:
          throw Exception(
            'Network error occurred. Please check your connection and try again.',
          );
        default:
          if (e.response?.statusCode == 401) {
            throw Exception('Your session has expired. Please log in again.');
          } else if (e.response?.statusCode == 404) {
            AppLogger.error(
              "=====================>>>   404 Error - Endpoint not found: ${e.requestOptions.uri}",
            );
            throw Exception(
              'API endpoint not found. Please check server configuration.',
            );
          } else {
            throw Exception(
              e.response?.data?['message'] ??
                  'Network error occurred. Please try again.',
            );
          }
      }
    } catch (e) {
      AppLogger.error("=====================>>>   Unexpected Error: $e");
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
