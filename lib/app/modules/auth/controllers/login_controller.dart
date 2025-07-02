/// lib/app/modules/auth/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/login_post_service.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final loginService = LoginPostService();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password are required');
      return;
    }
    isLoading.value = true;
    try {
      final response = await loginService.login(
        email: email,
        password: password,
      );
      if (response['success'] == true) {
        // Handle successful login (e.g., save token, navigate)
        Get.snackbar('Success', 'Login successful');
      } else {
        Get.snackbar('Login Failed', response['message'] ?? 'Unknown error');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

