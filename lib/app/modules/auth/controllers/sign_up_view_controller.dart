import 'package:canuck_mall/app/data/netwok/sign_up_post_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';

class SignUpViewController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordIsIncorrect = TextEditingController();
  final phoneController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final signupService = SignUpPostService();

  Future<void> signUp() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordTextEditingController.text.trim();
    final confirmPassword = confirmPasswordIsIncorrect.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      errorMessage.value = 'All fields are required';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    isLoading.value = true;
    try {
      final result = await signupService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      print('Signup response: $result');

      if (result['success'] == true) {
        Get.snackbar('Success', 'Account created. OTP sent.');
        Get.toNamed(Routes.verifyOtp, arguments: {'email': email, 'phone': phoneController.text});
      } else {
        errorMessage.value = result['message'] ?? 'Signup failed';
        Get.snackbar('Signup Failed', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordIsIncorrect.dispose();
    super.onClose();
  }
}