// File: lib/app/modules/auth/controllers/verify_otp_view_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/verify_signup_service.dart';
import 'package:canuck_mall/app/data/netwok/forget_password_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';

class VerifyOtpViewController extends GetxController {
  var remaining = 120.obs;
  Timer? _timer;

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
      final result = await _forgetPasswordService.verifyOtp(email: email.value, otp: otpInt);
      if (result['success'] == true && result['token'] != null) {
        token.value = result['token'];
        Get.toNamed(Routes.resetPassword, arguments: {'token': token.value});
        return true;
      } else {
        errorMessage.value = result['message'] ?? 'Invalid OTP';
        return false;
      }
    } else {
      final result = await _verifySignupService.verifyEmail(email: email.value, otp: otpInt);
      if (result['success'] == true) {
        Get.snackbar('Success', 'Your email is now verified.');
        Get.offAllNamed(Routes.login);
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

    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      if (args['email'] != null) email.value = args['email'];
      if (args['from'] != null) from = args['from'];
    } else if (args is String) {
      email.value = args;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
