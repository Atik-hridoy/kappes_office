import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPostService {
  final String baseUrl = 'http://10.0.60.110:7000/api/v1';

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users');
    try {
      final response = await http.post(
        url,

        body: ({
          'full_name': name,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, ...jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Sign up failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
