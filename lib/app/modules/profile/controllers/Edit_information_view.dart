import 'dart:io';

import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditInformationViewController extends GetxController{
  final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx<File?>(null);

  Future<void> pickImage() async {

    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
    } catch (e,stackTrace) {
      Get.snackbar(
        'Error',
        'Error picking image: $e',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      AppUtils.appError("$e\n$stackTrace");
    } finally {
      // something .......
    }
  }
}