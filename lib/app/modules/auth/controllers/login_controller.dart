import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isRemember = false.obs;
  final errorMessage = ''.obs;

  final Dio _dio = Dio();

  /// LOGIN FUNCTION
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email and password are required';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    await _handleRememberMe(isRemember.value);
    isLoading.value = true;

    try {
      print('🚀 Sending login request for $email...');
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.login}',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      final data = response.data;
      print('✅ Login API response: $data');

      if (data['success'] == true && data['data'] != null) {
        final nested = data['data'];

        final token = nested['accessToken'] ?? nested['token'] ?? '';
        final refreshToken = nested['refreshToken'] ?? '';

        if (token.isEmpty) {
          print('❌ Token missing in login response.');
          errorMessage.value = 'Token missing in login response';
          return false;
        }

        // Clear old and save new
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        await LocalStorage.setString(LocalStorageKeys.token, token);
        await LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken);
        await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);

        print('💾 Token saved to storage');
        print('   - accessToken: ✅');
        print('   - refreshToken: ${refreshToken.isNotEmpty ? '✅' : '❌'}');

        // 👉 fetch and save user profile
        await fetchAndSaveProfile();

        // Reload all stored preferences
        await LocalStorage.getAllPrefData();

        print('🎉 Login process complete. Name: ${LocalStorage.myName}, Email: ${LocalStorage.myEmail}');
        errorMessage.value = '';
        return true;
      } else {
        errorMessage.value = data['message'] ?? 'Login failed';
        print('❌ Login failed: ${errorMessage.value}');
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Login error: $e';
      print('❌ Exception during login: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH PROFILE AFTER LOGIN
  Future<void> fetchAndSaveProfile() async {
    try {
      final token = LocalStorage.token;

      print('🔎 Fetching user profile from ${AppUrls.profile}...');
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.profile}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final profileData = response.data;
      print('📦 Profile response: $profileData');

      if (profileData['success'] == true && profileData['data'] != null) {
        final profile = profileData['data'];
        final name = profile['full_name'] ?? '';
        final email = profile['email'] ?? '';
        final userId = profile['_id'] ?? '';

        await LocalStorage.setString(LocalStorageKeys.myName, name);
        await LocalStorage.setString(LocalStorageKeys.myEmail, email);
        await LocalStorage.setString(LocalStorageKeys.userId, userId);

        print('✅ Profile saved to LocalStorage');
        print('   - Name: $name');
        print('   - Email: $email');
        print('   - UserId: $userId');
      } else {
        print('⚠️ Failed to retrieve profile: ${profileData['message']}');
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
    }
  }

  /// REMEMBER ME
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

  /// ON INIT
  @override
  void onInit() {
    super.onInit();
    checkRememberMe();
  }

  /// AUTO FILL LOGIN IF REMEMBERED
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

        print('🔁 Auto-login with remembered credentials...');
        await login();
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
