import 'dart:io';
import 'package:dio/dio.dart';

import '../../../constants/app_urls.dart';


class EditInformationViewService {
  final Dio _dio = Dio();

  // Function to update profile information
  Future<bool> updateProfile(
      String fullName,
      String email,
      String phone,
      String address,
      File? imageFile,
      ) async {
    final String url = '${AppUrls.baseUrl}${AppUrls.profile}'; // The PATCH endpoint

    try {
      FormData formData = FormData.fromMap({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
      });

      // If an image is present, add it to the FormData
      if (imageFile != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }

      // Send the PATCH request (use patch instead of post)
      final response = await _dio.patch(url, data: formData);

      // Check the server response
      if (response.statusCode == 200) {
        print('Profile updated successfully!');
        return true; // Successfully updated profile
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return false; // Failure response from the server
      }
    } catch (e) {
      if (e is DioError) {
        print('DioError occurred: ${e.response?.data ?? e.message}');
        // Handle Dio-specific errors (e.g., network issues, server unavailability)
      } else {
        print('Error occurred: $e');
      }
      return false; // Return false if an error occurred
    }
  }
}
