import 'dart:io';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canuck_mall/app/data/netwok/profile/edit_information_service.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';

class EditInformationViewController extends GetxController {
  // ✅ Add this to fix the isLoading error
  final isLoading = false.obs;

  final imageFile = Rxn<File>();
  final fullName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;

  final EditInformationViewService _service = EditInformationViewService();

  @override
  void onInit() {
    super.onInit();
    fullName.value = LocalStorage.myName;
    email.value = LocalStorage.myEmail;
    phone.value = ''; // preload if available
    address.value = ''; // preload if available
    AppLogger.info('✅ Loaded user from LocalStorage: $fullName | $email');
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
      AppLogger.info('🖼️ Image selected: ${picked.path}');
    }
  }

  Future<void> updateProfile() async {
    // Prevent sending "undefined" strings
    final name = fullName.value.trim();
    final mail = email.value.trim();
    final mobile = phone.value.trim();
    final addr = address.value.trim();

    if ([name, mail, mobile, addr].any((v) => v.isEmpty)) {
      Get.snackbar('Error', 'All fields must be filled');
      return;
    }

    isLoading.value = true;
    AppLogger.info('🔄 Attempting to update profile...');
    AppLogger.info('📦 Sending: $name | $mail | $mobile | $addr');

    try {
      final success = await _service.updateProfile(
        name,
        mail,
        mobile,
        addr,
        imageFile.value,
      );

      if (success) {
        await LocalStorage.setString(LocalStorageKeys.myName, name);
        await LocalStorage.setString(LocalStorageKeys.myEmail, mail);
        await LocalStorage.getAllPrefData();

        AppLogger.info('✅ Profile updated & LocalStorage synced');
        Get.back(result: true);
        Get.snackbar('Success', 'Profile updated successfully!');
      } else {
        AppLogger.error('❌ Update failed on server side');
        Get.snackbar('Error', 'Failed to update profile. Try again later.');
      }
    } catch (e) {
      AppLogger.error('❗ Exception: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
