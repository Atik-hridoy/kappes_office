import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';
import '../../../model/password_change_model.dart';

class ChangePasswordService {
  final Dio _dio = Dio();

  Future<PasswordChangeResponse> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      print('=====>>> Sending PATCH request to change password...');
      final data = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.changePassword}',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('=====>>> Status: \x1B[32m[0m${response.statusCode}\x1B[0m');
      print('=====>>> Response Data: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        return PasswordChangeResponse.fromJson(response.data);
      } else {
        throw Exception(
          response.data?['message'] ?? 'Failed to change password',
        );
      }
    } catch (e) {
      print('=====>>> ERROR during password change: $e');
      rethrow;
    }
  }
}
