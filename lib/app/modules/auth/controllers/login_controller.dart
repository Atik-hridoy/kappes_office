import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canuck_mall/app/data/netwok/auth/login_post_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';

import '../../../data/local/storage_keys.dart';
import '../../../data/local/storage_service.dart';

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

    // Handle remember me
    await _handleRememberMe(isRemember.value);

    print('🚀 Starting login process for email: $email');
    isLoading.value = true;

    try {
      print('📡 Sending login request to server...');
      final response = await loginService.login(
        email: email,
        password: password,
      );

      print('✅ Received login response: ${response.toString()}');

      if (response['success'] == true) {
        final responseData = response['data'];
        print('=================== Login Response Data: $responseData');

        if (responseData != null) {
          // Check if responseData has a nested 'data' object
          final data = responseData is Map && responseData.containsKey('data')
              ? responseData['data'] ?? {}
              : responseData;

          final token = data['accessToken'] ?? data['token'] ?? '';
          final refreshToken = data['refreshToken'] ?? '';

          // Extract user data - check different possible locations
          final userData = data['user'] ?? data;
          final fullName = userData['full_name'] ??
                          userData['name'] ??
                          data['full_name'] ??
                          data['name'] ??
                          '';

          final email = userData['email'] ?? data['email'] ?? '';

          print('=================== Extracted User Data:');
          print('   - Token: ${token.isNotEmpty ? '✅' : '❌'}');
          print('   - Full Name: $fullName');
          print('   - Email: $email');

          // Clear any existing data first
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          
          // Store the data using the same keys as signup
          await LocalStorage.setString(LocalStorageKeys.token, token);
          await LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken);
          await LocalStorage.setString(LocalStorageKeys.myName, fullName);
          await LocalStorage.setString(LocalStorageKeys.myEmail, email);
          await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);
          
          print('💾 Saved user data to LocalStorage');
          print('   - Name: $fullName');
          print('   - Email: $email');
          print('   - Token: ${token.isNotEmpty ? '✅' : '❌'}');

          // Force reload all preferences
          await LocalStorage.getAllPrefData();
          
          // Verify the data was stored correctly
          print('\n🔍 Verifying stored data:');
          print('   - Stored Name: ${LocalStorage.myName.isNotEmpty ? '✅ ${LocalStorage.myName}' : '❌ Not stored'}');
          print('   - Stored Email: ${LocalStorage.myEmail.isNotEmpty ? '✅ ${LocalStorage.myEmail}' : '❌ Not stored'}');
          print('   - Stored Token: ${prefs.getString(LocalStorageKeys.token)?.isNotEmpty == true ? '✅ Verified' : '❌ Not found'}');
          print('   - Login Status: ${prefs.getBool(LocalStorageKeys.isLogIn) == true ? '✅ Logged In' : '❌ Not logged in'}\n');
          
          errorMessage.value = '';
          Get.snackbar('Success', 'Login successful');
          print('🎉 Login process completed successfully!');
          return true;
        } else {
          errorMessage.value = 'Login successful but no user data received';
          print('⚠️ $errorMessage');
          Get.snackbar('Error', errorMessage.value);
          return false;
        }
      } else {
        errorMessage.value = response['message'] ?? 'Login failed';
        print('❌ Login failed: ${errorMessage.value}');
        Get.snackbar('Login Failed', errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print('❌ Exception during login: $e');
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkRememberMe();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Check if remember me was enabled and auto-fill credentials
  Future<void> checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final isRemembered = prefs.getBool('rememberMe') ?? false;
    
    if (isRemembered) {
      final savedEmail = prefs.getString('savedEmail') ?? '';
      final savedPassword = prefs.getString('savedPassword') ?? '';
      
      if (savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        isRemember.value = true;
        // Auto-login if we have credentials
        await login();
      }
    }
  }

  // Save or clear remember me state
  Future<void> _handleRememberMe(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    if (remember) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('savedEmail', emailController.text.trim());
      await prefs.setString('savedPassword', passwordController.text.trim());
    } else {
      await prefs.setBool('rememberMe', false);
      await prefs.remove('savedEmail');
      await prefs.remove('savedPassword');
    }
  }
}
