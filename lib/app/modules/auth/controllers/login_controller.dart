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
  final errorMessage = ''.obs;

  final Dio _dio = Dio();

  /// LOGIN FUNCTION
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email and password are required';
      AppLogger.warning(
        'Login attempt with empty credentials',
        tag: 'AUTH',
        context: {'email': email.isEmpty ? 'empty' : 'provided'},
      );
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    await _handleRememberMe(isRemember.value);
    isLoading.value = true;

    try {
      AppLogger.auth(
        'Login attempt initiated',
        context: {'email': email, 'rememberMe': isRemember.value},
      );

      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.login}',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = response.data;
      AppLogger.auth(
        'Login API response received',
        context: {
          'success': data['success'] ?? false,
          'hasData': data['data'] != null,
        },
      );

      if (data['success'] == true && data['data'] != null) {
        final nested = data['data'];

        final token = nested['accessToken'] ?? nested['token'] ?? '';
        final refreshToken = nested['refreshToken'] ?? '';

        if (token.isEmpty) {
          AppLogger.error(
            'Token missing in login response',
            tag: 'AUTH',
            context: {'responseData': data},
          );
          errorMessage.value = 'Token missing in login response';
          return false;
        }

        // Clear old and save new
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        await LocalStorage.setString(LocalStorageKeys.token, token);
        await LocalStorage.setString(
          LocalStorageKeys.refreshToken,
          refreshToken,
        );
        await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);

        AppLogger.storage(
          'Login tokens saved to storage',
          context: {
            'hasAccessToken': token.isNotEmpty,
            'hasRefreshToken': refreshToken.isNotEmpty,
          },
        );

        // 👉 fetch and save user profile
        await fetchAndSaveProfile();

        // Reload all stored preferences
        await LocalStorage.getAllPrefData();

        AppLogger.success(
          'Login process completed successfully',
          context: {
            'userName': LocalStorage.myName,
            'userEmail': LocalStorage.myEmail,
          },
        );
        errorMessage.value = '';
        return true;
      } else {
        errorMessage.value = data['message'] ?? 'Login failed';
        AppLogger.failure(
          'Login failed',
          context: {'errorMessage': errorMessage.value, 'responseData': data},
        );
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        final dioError = e.response;
        final statusCode = dioError?.statusCode;
        final statusMessage = dioError?.statusMessage;

        AppLogger.error(
          'Login network error',
          tag: 'AUTH',
          context: {
            'statusCode': statusCode,
            'statusMessage': statusMessage,
            'error': e.toString(),
          },
        );
        errorMessage.value = 'Login failed: $statusMessage';
      } else {
        AppLogger.error(
          'Login exception',
          tag: 'AUTH',
          context: {
            'error': e.toString(),
            'errorType': e.runtimeType.toString(),
          },
        );
        errorMessage.value = 'Login error: $e';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH PROFILE AFTER LOGIN
  Future<void> fetchAndSaveProfile() async {
    try {
      final token = LocalStorage.token;

      AppLogger.auth(
        'Fetching user profile',
        context: {'endpoint': AppUrls.profile, 'hasToken': token.isNotEmpty},
      );

      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.profile}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final profileData = response.data;
      AppLogger.auth(
        'Profile response received',
        context: {
          'success': profileData['success'] ?? false,
          'hasData': profileData['data'] != null,
        },
      );

      if (profileData['success'] == true && profileData['data'] != null) {
        final profile = profileData['data'];
        final name = profile['full_name'] ?? '';
        final email = profile['email'] ?? '';
        final userId = profile['_id'] ?? '';

        await LocalStorage.setString(LocalStorageKeys.myName, name);
        await LocalStorage.setString(LocalStorageKeys.myEmail, email);
        await LocalStorage.setString(LocalStorageKeys.userId, userId);

        AppLogger.storage(
          'User profile saved to LocalStorage',
          context: {'name': name, 'email': email, 'userId': userId},
        );
      } else {
        AppLogger.warning(
          'Failed to retrieve profile',
          tag: 'AUTH',
          context: {
            'message': profileData['message'],
            'responseData': profileData,
          },
        );
      }
    } catch (e) {
      AppLogger.error(
        'Error fetching profile',
        tag: 'AUTH',
        context: {'error': e.toString(), 'errorType': e.runtimeType.toString()},
      );
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

        AppLogger.auth(
          'Auto-login with remembered credentials',
          context: {
            'hasEmail': savedEmail.isNotEmpty,
            'hasPassword': savedPassword.isNotEmpty,
          },
        );
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
