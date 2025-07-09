import 'package:canuck_mall/app/data/netwok/auth/sign_up_post_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

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
    print('🚀 Starting signup process...');
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordTextEditingController.text.trim();
    final confirmPassword = confirmPasswordIsIncorrect.text.trim();

    print('📝 Form data:');
    print('   - Full Name: $fullName');
    print('   - Email: $email');
    print('   - Password: ${'*' * password.length}');

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      errorMessage.value = 'All fields are required';
      print('❌ Validation failed: ${errorMessage.value}');
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      print('❌ Validation failed: ${errorMessage.value}');
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    print('✅ Form validation passed');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('📡 Sending signup request to server...');
      final result = await signupService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      print('📥 Server response received');
      print('   - Success: ${result['success']}');
      print('   - Message: ${result['message'] ?? 'No message'}');

      if (result['success'] == true) {
        print('💾 Saving user data to LocalStorage...');
        print('   - Saving name: $fullName');
        await LocalStorage.setString(LocalStorageKeys.myName, fullName);
        
        print('   - Saving email: $email');
        await LocalStorage.setString(LocalStorageKeys.myEmail, email);
        
        print('   - Setting login status: true');
        await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);
        
        print('🔄 Loading all preferences...');
        await LocalStorage.getAllPrefData();
        
        print('✅ User data saved successfully');
        print('📲 Navigating to OTP verification screen');
        
        Get.snackbar('Success', 'Account created. OTP sent.');
        Get.offAllNamed(Routes.verifyOtp, arguments: {
          'email': email, 
          'phone': phoneController.text,
          'from': 'signup'
        });
      } else {
        errorMessage.value = result['message'] ?? 'Signup failed';
        print('❌ Signup failed: ${errorMessage.value}');
        Get.snackbar('Signup Failed', errorMessage.value);
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'An error occurred: $e';
      print('❌ Exception during signup:');
      print('   - Error: $e');
      print('   - Stack trace: $stackTrace');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
      print('🏁 Signup process completed');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
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