import 'package:canuck_mall/app/data/netwok/auth/forget_password_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordViewController extends GetxController {
  final ForgetPasswordService _forgetPasswordService = ForgetPasswordService();
  
  // Form state
  final formKey = GlobalKey<FormState>();
  
  // Controllers
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observables
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  
  // Email and token from previous screen
  late String email;
  late String token;

  @override
  void onInit() {
    super.onInit();
    // Get email and token from arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      email = args['email']?.toString() ?? '';
      token = args['token']?.toString() ?? '';
    }
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;
    
    final newPassword = passwordTextEditingController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    
    if (newPassword != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      return;
    }
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('Reset Password Request:');
      print('Email: $email');
      print('Token: $token');
      print('New Password: $newPassword');
      print('Confirm Password: $confirmPassword');
      
      print('Using token for password reset: $token');
      
      final result = await _forgetPasswordService.resetPassword(
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        token: token,
      );
      
      print('Reset password response: $result');
      
      print('Reset Password Response: $result');
      
      isLoading.value = false;
      
      if (result['success'] == true) {
        // Close any open dialogs first
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        
        // Navigate to login first to prevent any context issues
        await Get.offAllNamed(Routes.login);
        
        // Show success message after navigation
        if (Get.isSnackbarOpen) {
          Get.back();
        }
        
        Get.snackbar(
          'Success',
          'Your password has been reset successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        final errorMsg = result['message']?.toString() ?? 'Failed to reset password';
        errorMessage.value = errorMsg;
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred. Please try again.';
      Get.snackbar(
        'Error',
        'An error occurred while resetting your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  // Removed showSuccessMessage method as we're now using snackbar

  @override
  void onClose() {
    passwordTextEditingController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}