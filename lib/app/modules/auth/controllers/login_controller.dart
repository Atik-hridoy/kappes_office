import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/login_post_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isRemember = false.obs;
  final errorMessage = ''.obs;
  final loginService = LoginPostService();

  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email and password are required';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }
    isLoading.value = true;
    try {
      final response = await loginService.login(
        email: email,
        password: password,
      );
      if (response['success'] == true) {
        // Extract and store token if present
        final token = response['data']['accessToken'] ;
        print('LoginController: token used/saved: =======================>>>>>>>>>>>>\\${token ?? 'No token'}');
        if (token != null) {
          LocalStorage.token = token;
          print("LocalStorage.token =====>>>> ${LocalStorage.token}");
        }
        // if (isRemember.value && token != null) {
        //   await storage.write(key: 'remember_me', value: 'true');
        // } else {
        //   await storage.delete(key: 'remember_me');
        // }
        errorMessage.value = '';
        Get.snackbar('Success', 'Login successful');
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Unknown error';
        Get.snackbar('Login Failed', errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar('Error', errorMessage.value);
      return false;
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
