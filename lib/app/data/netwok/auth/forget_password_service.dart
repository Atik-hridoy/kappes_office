import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ForgetPasswordService {
  final Dio _dio;

  ForgetPasswordService({Dio? dio}) : _dio = dio ?? Dio();

  // Accepts only email for OTP request
  Future<Map<String, dynamic>> requestOtp({required String email}) async {
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    try {
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.forgetPassword}',
        data: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return {'success': true, ...response.data as Map<String, dynamic>};
      } else {
        return {
          'success': false,
          'message': response.data['message']?.toString() ?? 'OTP request failed',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message']?.toString() ?? 'Network error: ${e.message}',
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required int otp,
  }) async {
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    try {
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.verifyEmail}',
        data: {'email': email, 'oneTimeCode': otp},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return {'success': true, ...response.data as Map<String, dynamic>};
      } else {
        return {
          'success': false,
          'message': response.data['message']?.toString() ?? 'OTP verification failed',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message']?.toString() ?? 'Network error: ${e.message}',
      };
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    try {
      final url = '${AppUrls.baseUrl}${AppUrls.resetPassword}';
      final requestData = {
        'email': email,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
      
      print('Making reset password request to: $url');
      print('Request data: $requestData');
      print('Using token: $token');
      
      // Try with POST first, as it's more common for password updates
      final response = await _dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return {'success': true, ...response.data as Map<String, dynamic>};
      } else {
        final errorMessage = response.data['message']?.toString() ?? 'Password reset failed (Status: ${response.statusCode})';
        print('Error response: $errorMessage');
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message']?.toString() ?? 'Network error: ${e.message}',
      };
    }
  }
}