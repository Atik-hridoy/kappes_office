import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/forget_password_service.dart';

class ForgotPasswordViewController extends GetxController {
  final ForgetPasswordService _service = ForgetPasswordService();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> resetPassword() async {
    final form = formKey.currentState;
    if (form == null) {
      Get.snackbar('Error', 'Form not found.');
      return;
    }
    if (!form.validate()) {
      return;
    }
    final email = emailController.text.trim();
    // if (email.isEmpty) {
    //   Get.snackbar('Error', 'Email cannot be empty.');
    //   return;
    // }
    try {
      isLoading.value = true;
      final result = await _service.requestOtp(email: email);
      isLoading.value = false;
      debugPrint('ForgotPasswordViewController.resetPassword result: $result');
      if (result != null && result is Map && result['success'] == true) {
        Get.toNamed('/verify-otp', arguments: {'email': email, 'from': 'forgot'});
      } else {
        final msg = (result is Map && result['message'] != null)
            ? result['message']
            : 'Failed to send OTP';
        Get.snackbar('Error', msg);
      }
    } catch (e, stackTrace) {
      isLoading.value = false;
      debugPrint('ForgotPasswordViewController.resetPassword error: $e\n$stackTrace');
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
