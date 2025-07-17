import 'package:dio/dio.dart';
import 'dart:convert'; // Import the jsonEncode function

import '../../../constants/app_urls.dart';

class ChangePasswordService {
  final Dio _dio = Dio();

  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token, // Token to authenticate the request
  }) async {
    try {
      print('Sending request to change password...');
      print('Request Data:');
      print('Current Password: $currentPassword');
      print('New Password: $newPassword');
      print('Confirm Password: $confirmPassword');

      final formData = FormData();
      formData.fields.add(MapEntry(
        "data",
        jsonEncode({
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        }),
      ));

      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status! < 500,
      );

      final response = await _dio.patch(
        '${AppUrls.baseUrl}${AppUrls.changePassword}',
        data: formData,
        options: options,
      );

      print('Response received:');
      print('Status Code: [32m${response.statusCode}[0m');
      print('Response Data: ${response.data}');

      return response;
    } catch (e) {
      print('Error occurred while changing password:');
      print(e.toString());
      rethrow;
    }
  }
}
