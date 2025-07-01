import 'package:canuck_mall/app/modules/auth/controllers/forgot_password_view_controller.dart';
import 'package:canuck_mall/app/modules/auth/controllers/reset_password_view_controller.dart';
import 'package:canuck_mall/app/modules/auth/controllers/sign_up_view_controller.dart';
import 'package:canuck_mall/app/modules/auth/controllers/verify_otp_view_controller.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<SignUpViewController>(
      () => SignUpViewController(),
    );
    Get.lazyPut<ForgotPasswordViewController>(
      () => ForgotPasswordViewController(),
    );
    Get.lazyPut<ResetPasswordViewController>(
          () => ResetPasswordViewController(),
    );
    Get.lazyPut<VerifyOtpViewController>(
          () => VerifyOtpViewController(),
    );
  }
}
