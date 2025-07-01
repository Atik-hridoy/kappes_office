import 'dart:async';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/verify_signup_service.dart';
import 'package:canuck_mall/app/data/netwok/forget_password_service.dart';

class VerifyOtpViewController extends GetxController {
  // 2 minutes in seconds
  var remaining = 120.obs;
  Timer? _timer;

  // Add OTP and error state
  RxString otpCode = ''.obs;
  RxString errorMessage = ''.obs;
  RxString email = ''.obs;
  RxString token = ''.obs;
  String from = '';

  final VerifySignupService _verifySignupService = VerifySignupService();
  final ForgetPasswordService _forgetPasswordService = ForgetPasswordService();

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
    errorMessage.value = '';
    final otpInt = int.tryParse(otpCode.value);
    if (otpInt == null) {
      errorMessage.value = 'OTP must be a number';
      return false;
    }
    if (from == 'forgot') {
      // Use forget password OTP verification
      final result = await _forgetPasswordService.verifyOtp(email: email.value, otp: otpInt);
      if (result['success'] == true && result['token'] != null) {
        token.value = result['token'];
        // Navigate to reset password, pass token
        Get.toNamed('/reset-password', arguments: {'token': token.value});
        return true;
      } else {
        errorMessage.value = result['message'] ?? 'Invalid OTP';
        return false;
      }
    } else {
      // ...existing code for signup OTP...
      final result = await _verifySignupService.verifyEmail(email: email.value, otp: otpInt);
      if (result['success'] == true) {
        return true;
      } else {
        errorMessage.value = result['message'] ?? 'Invalid OTP';
        return false;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    // Get email and from arguments if available
    final args = Get.arguments;
    if (args != null && args['email'] != null) {
      email.value = args['email'];
    }
    if (args != null && args['from'] != null) {
      from = args['from'];
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}