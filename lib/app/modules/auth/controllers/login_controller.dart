import 'dart:convert';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isRemember = false.obs;
  final RxString errorMessage = ''.obs;
  final Dio _dio = Dio();

  // Centralized function for login validation and authentication
  Future<bool> login() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        return _handleError('Email and password are required');
      }

      await _handleRememberMe(isRemember.value);
      isLoading.value = true;

      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.login}',
        data: jsonEncode({'email': email, 'password': password}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
        ),
      );
      
      AppLogger.debug('Login response received', tag: 'AUTH', context: response.data);

      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        await _storeTokens(data['data']);
        await fetchAndSaveProfile();
        
        // Force update the auth state
        await LocalStorage.getAllPrefData();
        return true;
      } else {
        return _handleError(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      return _handleError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Centralized error handler
  bool _handleError(String message) {
    errorMessage.value = message;
    AppLogger.error('Login Error', tag: 'AUTH', context: {'error': message}, error: message);
    Get.snackbar('Error', message);
    return false;
  }

  // Save tokens to local storage
  Future<bool> _storeTokens(Map<String, dynamic> data) async {
    try {
      final token = data['accessToken'] ?? data['token'] ?? '';
      final refreshToken = data['refreshToken'] ?? '';

      if (token.isEmpty) {
        return _handleError('Token missing in login response');
      }

      // Save tokens and update login state
      await Future.wait([
        LocalStorage.setString(LocalStorageKeys.token, token),
        LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken),
        LocalStorage.setBool(LocalStorageKeys.isLogIn, true),
      ]);
      
      // Force reload the storage values
      await LocalStorage.getAllPrefData();
      
      AppLogger.storage('Login tokens saved to storage', context: {
        'token': token,
        'isLoggedIn': LocalStorage.isLogIn
      });
      
      return true;
    } catch (e) {
      AppLogger.error('Error storing tokens', error: e.toString(), tag: 'AUTH');
      return false;
    }
  }

  // Fetch and store user profile after successful login
  Future<void> fetchAndSaveProfile() async {
    try {
      final token = LocalStorage.token;
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.profile}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final profileData = response.data;
      if (profileData['success'] == true && profileData['data'] != null) {
        await _saveUserProfile(profileData['data']);
      } else {
        AppLogger.warning('Failed to retrieve profile', tag: 'AUTH');
      }
    } catch (e) {
      AppLogger.error('Error fetching profile', tag: 'AUTH', context: {'error': e.toString()}, error: e.toString());
    }
  }

  // Save user profile data
  Future<void> _saveUserProfile(Map<String, dynamic> profile) async {
    final profileJson = jsonEncode(profile);
    await LocalStorage.setString('user_profile', profileJson);
    await Future.wait([
      LocalStorage.setString(LocalStorageKeys.myName, profile['full_name'] ?? ''),
      LocalStorage.setString(LocalStorageKeys.myEmail, profile['email'] ?? ''),
      // Other fields to save...
    ]);
  }

  // Handle the "Remember Me" functionality
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

  @override
  void onReady() {
    super.onReady();
    _checkRememberMe();
  }

  // Auto-login based on remembered credentials
  Future<void> _checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final isRemembered = prefs.getBool('rememberMe') ?? false;

    if (isRemembered) {
      final savedEmail = prefs.getString('savedEmail') ?? '';
      final savedPassword = prefs.getString('savedPassword') ?? '';
      if (savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        isRemember.value = true;
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

  // Logout function
  Future<void> logout() async {
    try {
      // Clear all local storage and reset login state
      await LocalStorage.clearAll(); // Clears the local storage including isLogIn and other data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', false); // Remove the rememberMe flag
      await prefs.remove('savedEmail');
      await prefs.remove('savedPassword');

      // Reset UI-related states
      emailController.clear();
      passwordController.clear();
      isRemember.value = false;

      AppLogger.auth('User logged out successfully');

      // Navigate to login screen after logout
      Get.offAllNamed(Routes.login);
    } catch (e) {
      AppLogger.error('Error during logout', tag: 'AUTH', context: {'error': e.toString()}, error: e.toString());
      rethrow;
    }
  }
}
