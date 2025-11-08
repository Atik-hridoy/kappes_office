import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ForgetPasswordService {
  final Dio _dio;
  String? _verifyToken; // Store the verify token after OTP verification

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

  // Resend OTP using dedicated endpoint
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    print('🔄 Resending OTP to: $email using ${AppUrls.resendOtp}');

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

      print('📥 Resend OTP Response Status: ${response.statusCode}');
      print('📥 Resend OTP Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return {'success': true, ...response.data as Map<String, dynamic>};
      } else {
        return {
          'success': false,
          'message': response.data['message']?.toString() ?? 'Failed to resend OTP',
        };
      }
    } on DioException catch (e) {
      print('❌ Resend OTP Error: ${e.message}');
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
    
    print('🔍 Verifying OTP for email: $email');

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
        // Store the verify token from the response
        final responseData = response.data as Map<String, dynamic>;
        _verifyToken = responseData['data']?['verifyToken']?.toString();
        
        if (_verifyToken != null) {
          print('🔑 Verify token stored successfully');
        } else {
          print('⚠️ No verify token found in the response');
        }
        
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

  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    String? token, // Make token optional since we store it
  }) async {
    // Use the stored token if none is provided
    final verifyToken = token ?? _verifyToken;
    
    if (verifyToken == null) {
      return {'success': false, 'message': 'Verification token is missing'};
    }
    
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    try {
      final url = '${AppUrls.baseUrl}${AppUrls.resetPassword}';
      
      // Log the token being used
      print('🔑 Using verify token: $verifyToken');
      
      final requestData = {
        'email': email,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'verifyToken': verifyToken,
      };
      
      // Add the reset token to the headers
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'resetToken': verifyToken,
      };
      
      print('Using reset token in header: $verifyToken');
      
      print('Making reset password request to: $url');
      print('Request data: $requestData');
      print('Using token: $token');
      
      // Try with POST first, as it's more common for password updates
      final response = await _dio.post(
        url,
        data: requestData,
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500,
        ),
      );
      
      // Clear the stored token after successful password reset
      if (response.statusCode == 200) {
        _verifyToken = null;
      }
      
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