import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ForgetPasswordService {
  // Accepts only email for OTP request
  Future<Map<String, dynamic>> requestOtp({required String email}) async {
    final url = Uri.parse(AppUrls.baseUrl + AppUrls.forgotPassword);
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }
    final body = {'email': email};
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return {'success': true, ...jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'OTP request failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Accepts only email for OTP verification
  Future<Map<String, dynamic>> verifyOtp({required String email, required int otp}) async {
    final url = Uri.parse(AppUrls.baseUrl + AppUrls.verifyEmail);
    if (email.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }
    final body = {'email': email, 'oneTimeCode': otp};
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return {'success': true, ...jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'OTP verification failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> resetPassword({required String token, required String newPassword, required String confirmPassword}) async {
    final url = Uri.parse(AppUrls.baseUrl + AppUrls.resetPassword);
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, ...jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Password reset failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
