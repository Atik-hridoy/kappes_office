import 'package:canuck_mall/app/data/netwok/auth/forget_password_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
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
      
      final result = await _forgetPasswordService.resetPassword(
        token: token,
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      
      print('Reset Password Response: $result');
      
      isLoading.value = false;
      
      if (result['success'] == true) {
        showSuccessMessage(Get.context!);
        
        // Navigate to login after a short delay
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(Routes.login);
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

  void showSuccessMessage(BuildContext context) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    'Success!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Your password has been reset successfully.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed(Routes.login);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      AppUtils.appError("Error in showSuccessMessage: $e\n$stackTrace");
    }
  }

  @override
  void onClose() {
    passwordTextEditingController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}