import 'dart:convert';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/utils/error_handling/auth_error_handler.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isRemember = false.obs;
  final RxString errorMessage = ''.obs;
  final Dio _dio = Dio();

  /// Validates the login form fields
  bool _validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty) {
      errorMessage.value = 'Please enter your email address';
      return false;
    }
    
    if (!GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      return false;
    }
    
    if (password.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }
    
    if (password.length < 8) {
      errorMessage.value = 'Password must be at least 8 characters long';
      return false;
    }
    
    errorMessage.value = '';
    return true;
  }

  /// Handles the login process
  Future<bool> login() async {
    if (!_validateForm()) {
      return false;
    }

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      
      await _handleRememberMe(isRemember.value);
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.login}',
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
          validateStatus: (status) => status! < 500,
        ),
      );
      
      AppLogger.debug(
        'Login response received',
        tag: 'AUTH',
        context: response.data,
        error: response.data.toString(),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        await _storeTokens(response.data['data']);
        await fetchAndSaveProfile();
        await LocalStorage.getAllPrefData();
        return true;
      } else {
        errorMessage.value = AuthErrorHandler.handleError(
          response.data['message'] ?? 'Login failed',
        );
        return false;
      }
    } on DioException catch (e) {
      errorMessage.value = AuthErrorHandler.handleError(e);
      return false;
    } catch (e, _) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      AppLogger.error(
        'Unexpected login error: ${e.toString()}',
        tag: 'AUTH',
        error: e,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Save tokens to local storage
  Future<bool> _storeTokens(Map<String, dynamic> data) async {
    try {
      final token = data['accessToken'] ?? data['token'] ?? '';
      final refreshToken = data['refreshToken'] ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token missing in login response';
        return false;
      }

      // Extract user ID from JWT token as fallback
      String? userIdFromToken;
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalizedPayload = base64Url.normalize(payload);
          final decoded = utf8.decode(base64Url.decode(normalizedPayload));
          final tokenData = jsonDecode(decoded);
          userIdFromToken = tokenData['id'];
          AppLogger.debug('🔑 [AUTH] Extracted user ID from token: $userIdFromToken', tag: 'AUTH', error: 'Extracted user ID from token: $userIdFromToken');
        }
      } catch (e) {
        AppLogger.warning('Could not extract user ID from token: $e', tag: 'AUTH');
      }

      // Save tokens and update login state
      await Future.wait([
        LocalStorage.setString(LocalStorageKeys.token, token),
        LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken),
        LocalStorage.setBool(LocalStorageKeys.isLogIn, true),
        if (userIdFromToken != null) LocalStorage.setString(LocalStorageKeys.userId, userIdFromToken),
      ]);
      
      // Force reload the storage values
      await LocalStorage.getAllPrefData();
      
      AppLogger.storage('Login tokens saved to storage', context: {
        'token': token,
        'userId': userIdFromToken,
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
      LocalStorage.setString(LocalStorageKeys.userId, profile['_id'] ?? profile['id'] ?? ''),
      LocalStorage.setString(LocalStorageKeys.myName, profile['full_name'] ?? profile['name'] ?? ''),
      LocalStorage.setString(LocalStorageKeys.myEmail, profile['email'] ?? ''),
      LocalStorage.setString(LocalStorageKeys.phone, profile['phone'] ?? profile['phoneNumber'] ?? ''),
      LocalStorage.setString(LocalStorageKeys.myAddress, profile['address'] ?? profile['shippingAddress'] ?? ''),
    ]);
  }

  // Handle the "Remember Me" functionality
  Future<void> _handleRememberMe(bool remember) async {
    try {
      if (remember) {
        await LocalStorage.setString('remembered_email', emailController.text);
      } else {
        // Clear the remembered email if not checked
        await LocalStorage.setString('remembered_email', '');
      }
    } catch (e) {
      AppLogger.error('Error handling remember me', tag: 'AUTH', error: e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Don't await here to avoid blocking UI
    checkRememberedEmail();
  }

  // Auto-login based on remembered credentials
  Future<void> checkRememberedEmail() async {
    try {
      final rememberedEmail = await LocalStorage.getString('remembered_email') ?? '';
      if (rememberedEmail.isNotEmpty) {
        emailController.text = rememberedEmail;
        isRemember.value = true;
      }
    } catch (e) {
      AppLogger.error('Error checking remembered email', tag: 'AUTH', error: e);
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
