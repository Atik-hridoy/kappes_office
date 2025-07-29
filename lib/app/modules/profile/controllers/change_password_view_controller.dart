import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import '../../../data/netwok/profile/change_password_service.dart';
import '../../../model/password_change_model.dart';

class ChangePasswordViewController extends GetxController {
  final TextEditingController currentPasswordTextEditingController = TextEditingController();
  final TextEditingController createPasswordTextEditingController = TextEditingController();
  final TextEditingController confirmPasswordTextEditingController = TextEditingController();

  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isCreatePasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final ChangePasswordService _changePasswordService = ChangePasswordService();

  final RxBool isLoading = false.obs;
  final Rx<PasswordChangeResponse?> passwordChangeResponse = Rx<PasswordChangeResponse?>(null);
  final RxString errorMessage = ''.obs;

  Future<void> changePassword() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _changePasswordService.changePassword(
        currentPassword: currentPasswordTextEditingController.text,
        newPassword: createPasswordTextEditingController.text,
        confirmPassword: confirmPasswordTextEditingController.text,
        token: LocalStorage.token,
      );
      passwordChangeResponse.value = response;
      if (response.success) {
        Get.snackbar('Success', response.message.isNotEmpty ? response.message : 'Password changed successfully!');
        currentPasswordTextEditingController.clear();
        createPasswordTextEditingController.clear();
        confirmPasswordTextEditingController.clear();
      } else {
        errorMessage.value = response.message.isNotEmpty ? response.message : 'Failed to change password. Please try again.';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
