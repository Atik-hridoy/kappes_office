import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpViewController extends GetxController{
  RxBool isRemember = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // controllers
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordIsIncorrect = TextEditingController();

  @override
  void onClose() {
    passwordTextEditingController.dispose();
    confirmPasswordIsIncorrect.dispose();
  }
}