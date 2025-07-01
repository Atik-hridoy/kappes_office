import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifySignupService {
  final String baseUrl = 'http://10.0.60.110:7000/api/v1';

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required int otp,
  }) async {
    final url = Uri.parse('$baseUrl/auth/verify-email');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'oneTimeCode': otp,
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, ...jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Verification failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
