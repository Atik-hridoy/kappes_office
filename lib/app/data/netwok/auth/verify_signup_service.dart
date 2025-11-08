// File: lib/app/data/netwok/verify_signup_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:canuck_mall/app/constants/app_urls.dart';

class VerifySignupService {
  /// Central OTP verification for both signup and forgot password
  /// Always send email and oneTimeCode to backend
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required int otp,
  }) async {
    final url = Uri.parse('${AppUrls.baseUrl}${AppUrls.verifyEmail}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'oneTimeCode': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract token from response if available
        final token = data['token']?.toString() ?? '';
        return {
          'success': true, 
          'data': data,
          'token': token, // Include token in the response
        };
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Invalid OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': 'OTP verification error: $e'};
    }
  }

  /// Resend OTP for signup verification
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    final url = Uri.parse('${AppUrls.baseUrl}${AppUrls.resendOtp}');
    
    print('🔄 Resending OTP to: $email using ${AppUrls.resendOtp}');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print('📥 Resend OTP Response Status: ${response.statusCode}');
      print('📥 Resend OTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, ...data};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to resend OTP'
        };
      }
    } catch (e) {
      print('❌ Resend OTP Error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}