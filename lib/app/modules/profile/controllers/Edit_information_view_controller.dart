import 'dart:io';
import 'package:get/get.dart';

import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../../data/netwok/profile/edit_information.dart';

class EditInformationViewController extends GetxController {
  var imageFile = Rxn<File>();
  var fullName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  final EditInformationViewService _service = EditInformationViewService();

  // Method to pick image using the ImagePicker package
  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imageFile.value = File(image.path);
    }
  }

  // Method to update the profile information
  Future<void> updateProfile() async {
    // Validate that all required fields are filled
    if (fullName.value.isEmpty || email.value.isEmpty || phone.value.isEmpty || address.value.isEmpty) {
      Get.snackbar('Error', 'All fields must be filled');
      return;
    }

    try {
      var response = await _service.updateProfile(
        fullName.value,
        email.value,
        phone.value,
        address.value,
        imageFile.value,
      );

      if (response) {
        Get.snackbar('Success', 'Profile updated successfully!');
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating profile: $e');
    }
  }
}
