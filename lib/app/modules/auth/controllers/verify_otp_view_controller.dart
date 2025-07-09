// File: lib/app/modules/auth/controllers/verify_otp_view_controller.dart
import 'dart:async';
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
    errorMessage.value = '';
    if (otpCode.value.isEmpty) {
      errorMessage.value = 'OTP is required';
      return false;
    }
    if (email.value.isEmpty) {
      errorMessage.value = 'Email is required';
      return false;
    }
    final otpInt = int.tryParse(otpCode.value);
    if (otpInt == null) {
      errorMessage.value = 'OTP must be a number';
      return false;
    }
    // Send both email and oneTimeCode in the body for OTP verification
    final result = await _verifySignupService.verifyOtp(
      email: email.value,
      otp: otpInt,
    );
    if (result['success'] == true) {
      Get.snackbar('Success', 'Your email is now verified.');
      Get.offAllNamed(Routes.login);
      return true;
    } else {
      errorMessage.value = result['message'] ?? 'Invalid OTP';
      return false;
    }
  }

  Future<void> onAppInitialDataLoadFun() async {
    try {
      startTimer();

      final args = Get.arguments;
      if (args != null && args is Map<String, dynamic>) {
        if (args['email'] != null) {
          email.value = args['email'].toString();
        }
      } else {
        errorMessage.value = 'Invalid arguments passed to VerifyOtpView';
      }
    } catch (e) {
      errorLog(e);
    }
  }

  @override
  void onInit() {
    super.onInit();

    onAppInitialDataLoadFun();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
