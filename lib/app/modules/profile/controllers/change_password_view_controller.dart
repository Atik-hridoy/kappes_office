import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import '../../../data/netwok/profile/change_password_service.dart';


class ChangePasswordViewController extends GetxController {
  final TextEditingController currentPasswordTextEditingController =
  TextEditingController();
  final TextEditingController createPasswordTextEditingController =
  TextEditingController();
  final TextEditingController confirmPasswordTextEditingController =
  TextEditingController();

  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isCreatePasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final ChangePasswordService _changePasswordService = ChangePasswordService();

  // Method to call the service to change the password
  Future<void> changePassword() async {
    try {
      final response = await _changePasswordService.changePassword(
        currentPassword: currentPasswordTextEditingController.text,
        newPassword: createPasswordTextEditingController.text,
        confirmPassword: confirmPasswordTextEditingController.text,
        token: LocalStorage.token,
      );

      if (response.statusCode == 200) {
        // Handle success (e.g., show success message, navigate to another screen)
        Get.snackbar('Success', 'Password changed successfully!');
      } else {
        // Handle failure
        Get.snackbar('Error', 'Failed to change password. Please try again.');
      }
    } catch (e) {
      // Handle exception (e.g., show error message)
      Get.snackbar('Error', 'An error occurred: ${e.toString()}');
    }
  }
}
