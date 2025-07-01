import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPasswordService {
  final String baseUrl = 'http://10.0.60.110:7000/api/v1';

  Future<Map<String, dynamic>> requestOtp({required String email}) async {
    final url = Uri.parse('$baseUrl/auth/forget-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
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

  Future<Map<String, dynamic>> verifyOtp({required String email, required int otp}) async {
    final url = Uri.parse('$baseUrl/auth/verify-email');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'oneTimeCode': otp}),
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
    final url = Uri.parse('$baseUrl/auth/reset-password');
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
