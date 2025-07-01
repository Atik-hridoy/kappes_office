import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordViewController extends GetxController{
  /////////////// variables /////////////////
  RxBool isCreatePasswordVisible = false.obs;
  RxBool isCurrentPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  ////////////// controllers ////////////////
  final createPasswordTextEditingController = TextEditingController();
  final currentPasswordTextEditingController = TextEditingController();
  final confirmPasswordTextEditingController = TextEditingController();

  @override
  void onClose() {
    createPasswordTextEditingController.dispose();
    currentPasswordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.onClose();
  }
}