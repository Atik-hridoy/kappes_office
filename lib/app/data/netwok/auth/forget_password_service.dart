import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ForgetPasswordService {
  final Dio _dio;
  String? _verifyToken;

  ForgetPasswordService({Dio? dio}) : _dio = dio ?? Dio();

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

  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    try {
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.resendOtp}',
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
          'message': response.data['message']?.toString() ?? 'Failed to resend OTP',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message']?.toString() ?? 'Network error: ${e.message}',
      };
    }
  }

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
        final responseData = response.data as Map<String, dynamic>;
        _verifyToken = responseData['data']?['verifyToken']?.toString();

        return {
          'success': true,
          ...responseData,
          'verifyToken': _verifyToken,
        };
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

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    String? token,
  }) async {
    final verifyToken = token ?? _verifyToken;

    if (verifyToken == null) {
      return {'success': false, 'message': 'Verification token is missing'};
    }

    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    try {
      final url = '${AppUrls.baseUrl}${AppUrls.resetPassword}';

      final requestData = {
        'email': email,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'verifyToken': verifyToken,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'resetToken': verifyToken,
      };

      final response = await _dio.post(
        url,
        data: requestData,
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        _verifyToken = null;
      }

      if (response.statusCode == 200) {
        return {'success': true, ...response.data as Map<String, dynamic>};
      } else {
        final errorMessage = response.data['message']?.toString() ?? 'Password reset failed (Status: ${response.statusCode})';
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