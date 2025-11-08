// File: lib/app/modules/auth/controllers/verify_otp_view_controller.dart
import 'dart:async';
import 'package:canuck_mall/app/data/netwok/auth/forget_password_service.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/log/error_log.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/auth/verify_signup_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';

class VerifyOtpViewController extends GetxController {
  var remaining = 120.obs;
  Timer? _timer;

  RxString otpCode = ''.obs;
  RxString errorMessage = ''.obs;
  RxString email = ''.obs;
  RxString token = ''.obs;
  String from = '';

  final ForgetPasswordService _forgetPasswordService = ForgetPasswordService();
  

  
  final VerifySignupService _verifySignupService = VerifySignupService();
  final RxBool isLoading = false.obs;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remaining.value > 0) {
        remaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String get formattedTime {
    final minutes = (remaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<bool> verifyOtp() async {
    // Prevent multiple simultaneous calls
    if (isLoading.value) {
      print('⚠️ OTP verification already in progress, ignoring duplicate call');
      return false;
    }
    
    print('=== Starting OTP Verification ===');
    print('Flow Type: $from');
    print('Email: ${email.value}');
    print('OTP Code: ${otpCode.value}');
    
    // Clear previous error message
    errorMessage.value = '';
    
    // Validate OTP format
    if (otpCode.value.isEmpty) {
      errorMessage.value = 'OTP is required';
      print('OTP verification failed: OTP is required');
      return false;
    }
    
    if (email.value.isEmpty) {
      errorMessage.value = 'Email is required';
      print('OTP verification failed: Email is required');
      return false;
    }
    
    final otpInt = int.tryParse(otpCode.value);
    if (otpInt == null) {
      errorMessage.value = 'OTP must be a number';
      print('OTP verification failed: OTP must be a number');
      return false;
    }
    
    print('All validations passed. Proceeding with OTP verification...');
    
    // Set loading state (button will show loading indicator)
    isLoading.value = true;
    
    try {
      Map<String, dynamic> result;
      
      if (from == 'forgot_password') {
        print(' Verifying OTP for password reset...');
        print('Calling _forgetPasswordService.verifyOtp with:');
        print('- Email: ${email.value}');
        print('- OTP: $otpInt');
        
        result = await _forgetPasswordService.verifyOtp(
          email: email.value,
          otp: otpInt,
        );
        
        print(' Forget password OTP verification response:');
        print(result);
      } else {
        print(' Verifying OTP for signup...');
        result = await _verifySignupService.verifyOtp(
          email: email.value,
          otp: otpInt,
        );
        print(' Signup OTP verification response:');
        print(result);
      }
      
      // Dismiss loading dialog
      if (Get.isDialogOpen ?? false) Get.back();
      
      if (result['success'] == true) {
        if (from == 'forgot_password') {
          // Extract verifyToken from the response data
          final token = result['data']?['verifyToken']?.toString() ?? '';
          
          if (token.isEmpty) {
            ErrorLogger.logCaughtError(
              'No token found in OTP verification response',
              StackTrace.current,
              tag: 'VerifyOtpViewController',
              context: {
                'email': email.value,
                'from': from,
                'response': result.toString(),
              },
            );
            print('Full response: $result');
          }
          print('✅ Password reset OTP verified successfully!');
          print('🔑 Token received: ${token.isNotEmpty ? 'Token received' : 'No token received!'}');
          print('🔄 Navigating to reset password screen...');
          
          // For password reset flow, navigate to reset password screen with token
          Get.offNamed(
            Routes.resetPassword,
            arguments: {
              'email': email.value,
              'token': token, // Token passed to reset password screen
            },
          );
        } else {
          // For signup verification flow
          print('✅ Email verified successfully!');
          Get.snackbar('Success', 'Your email is now verified.');
          Get.offAllNamed(Routes.login);
        }
        return true;
      } else {
        // Enhanced error handling
        String errorMsg = result['message']?.toString() ?? 'Invalid OTP';
        
        // Check for specific error cases
        if (errorMsg.toLowerCase().contains('expired')) {
          errorMsg = 'This OTP has expired. Please request a new one.';
          print('❌ OTP Error: OTP has expired');
        } else if (errorMsg.toLowerCase().contains('invalid') || 
                  errorMsg.toLowerCase().contains('incorrect')) {
          errorMsg = 'The OTP you entered is incorrect. Please try again.';
          print('❌ OTP Error: Incorrect OTP');
        } else {
          print('❌ OTP Error: $errorMsg');
        }
        
        print('💬 Showing error to user: $errorMsg');
        errorMessage.value = errorMsg;
        return false;
      }
    } catch (e) {
      // Dismiss loading dialog if shown
      if (Get.isDialogOpen ?? false) Get.back();
      
      errorMessage.value = 'An error occurred. Please try again.';
      print('Error during OTP verification: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onAppInitialDataLoadFun() async {
    try {
      startTimer();
      
      // Clear any previous error messages
      errorMessage.value = '';
      
      final args = Get.arguments;
      if (args != null && args is Map<String, dynamic>) {
        if (args['email'] == null || args['email'].toString().isEmpty) {
          errorMessage.value = 'Email is required for OTP verification';
          Get.back(); // Go back if no email is provided
          return;
        }
        
        email.value = args['email'].toString();
        
        if (args['from'] != null) {
          from = args['from'].toString();
        }
        
        // Log the received arguments for debugging
        print('VerifyOtpView - Email: ${email.value}, Flow: $from');
        
      } else {
        errorMessage.value = 'Invalid arguments passed to VerifyOtpView';
        Get.back(); // Go back if no arguments are provided
      }
    } catch (e, s) {
      ErrorLogger.logCaughtError(e, s, tag: 'VerifyOtpViewController');
    }
  }

  @override
  void onInit() {
    super.onInit();

    onAppInitialDataLoadFun();
  }

  Future<void> resendOtp() async {
    if (isLoading.value) {
      print('⚠️ Already processing, ignoring resend request');
      return;
    }
    
    if (email.value.isEmpty) {
      errorMessage.value = 'Email is required to resend OTP';
      return;
    }
    
    print('🔄 Resending OTP to: ${email.value}');
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      Map<String, dynamic> result;
      
      if (from == 'forgot_password') {
        // Use the dedicated resend OTP endpoint for forgot password
        result = await _forgetPasswordService.resendOtp(email: email.value);
      } else {
        // Use the dedicated resend OTP endpoint for signup
        result = await _verifySignupService.resendOtp(email: email.value);
      }
      
      if (result['success'] == true) {
        // Reset timer
        remaining.value = 120;
        _timer?.cancel();
        startTimer();
        
        Get.snackbar(
          'Success',
          'A new OTP has been sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary.withOpacity(0.8),
          colorText: AppColors.white,
        );
        print('✅ OTP resent successfully');
      } else {
        errorMessage.value = result['message']?.toString() ?? 'Failed to resend OTP';
        print('❌ Failed to resend OTP: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while resending OTP';
      print('Error resending OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}