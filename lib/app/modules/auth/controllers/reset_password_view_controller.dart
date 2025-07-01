import 'package:canuck_mall/app/modules/auth/widgets/dialogue_box.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordViewController extends GetxController{
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // controllers
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordIsIncorrect = TextEditingController();

  showSuccessMessage(BuildContext context){
    try{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogueBox();
        },
      );
    }catch(e,stackTrace){
      AppUtils.appError("error comes from showSuccessMessage : $e\n$stackTrace");
    }
  }

  @override
  void onClose() {
    passwordTextEditingController.dispose();
    confirmPasswordIsIncorrect.dispose();
  }
}