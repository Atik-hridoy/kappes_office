// File: lib/app/modules/auth/controllers/verify_otp_view_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/verify_signup_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';

class VerifyOtpViewController extends GetxController {
  var remaining = 120.obs;
  Timer? _timer;

  RxString otpCode = ''.obs;
  RxString errorMessage = ''.obs;
  RxString email = ''.obs;
  RxString token = ''.obs;
  String from = '';
  RxBool isForgetPassword = false.obs;

  final VerifySignupService _verifySignupService = VerifySignupService();

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
    print('[OTP] Starting verification');
    errorMessage.value = '';
    print('[OTP] Entered code: '
        '"${otpCode.value}"');
    if (otpCode.value.isEmpty) {
      errorMessage.value = 'OTP is required';
      print('[OTP] Error: OTP is required');
      return false;
    }
    if (email.value.isEmpty) {
      errorMessage.value = 'Email is required';
      print('[OTP] Error: Email is required');
      return false;
    }
    final otpInt = int.tryParse(otpCode.value);
    print('[OTP] Parsed int: $otpInt');
    if (otpInt == null) {
      errorMessage.value = 'OTP must be a number';
      print('[OTP] Error: OTP must be a number');
      return false;
    }
    print('[OTP] Calling verifyOtp with email: ${email.value}, otp: $otpInt');
    final result = await _verifySignupService.verifyOtp(email: email.value, otp: otpInt);
    print('[OTP] Backend result: $result');
    if (result['success'] == true) {
      Get.snackbar('Success', 'Your email is now verified.');
      print('[OTP] Success: Email verified, navigating to login');
      if(isForgetPassword.value) {
        Get.offAllNamed(Routes.resetPassword);
      } else {
        Get.offAllNamed(Routes.login);
      }
      return true;
    } else {
      errorMessage.value = result['message'] ?? 'Invalid OTP';
      print('[OTP] Error: ${errorMessage.value}');
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();

    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      if (args['email'] != null) {
        email.value = args['email'];
        // Also set otp input if needed
      }
      if (args['from'] != null) from = args['from'];
    } else if (args is String) {
      email.value = args;
    }
    print('[OTP] onInit: email=${email.value}, from=$from');
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
