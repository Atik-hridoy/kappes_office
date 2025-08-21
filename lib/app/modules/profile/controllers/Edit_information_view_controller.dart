// ignore_for_file: file_names

import 'dart:io';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canuck_mall/app/data/netwok/profile/edit_information_service.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class EditInformationViewController extends GetxController {
  // ✅ Add this to fix the isLoading error
  final isLoading = false.obs;
  final isFetching = false.obs; // for initial load/skeleton

  final imageFile = Rxn<File>();
  final fullName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;
  final profileImageUrl = ''.obs; // network image path or url

  final EditInformationViewService _service = EditInformationViewService();

  @override
  void onInit() {
    super.onInit();
    fullName.value = LocalStorage.myName;
    email.value = LocalStorage.myEmail;
    // Store the full phone number but don't include it in the display
    phone.value = LocalStorage.myPhone;
    address.value = LocalStorage.myAddress;
    AppLogger.info('✅ Loaded user from LocalStorage: $fullName | $email | $phone');
  }

  @override
  void onReady() {
    super.onReady();
    fetchLatestProfile();
  }

  /// Always fetch latest profile from server
  Future<void> fetchLatestProfile() async {
    isFetching.value = true;
    try {
      final data = await _service.getProfile();
      if (data != null) {
        // Try multiple key styles
        final name = (data['full_name'] ?? data['fullName'] ?? '').toString();
        final mail = (data['email'] ?? '').toString();
        final mobile = (data['phone'] ?? '').toString();
        final addr = (data['address'] ?? '').toString();
        // Image may be absolute or relative (e.g., '/uploads/..') or nested
        final rawImage = (data['image'] ?? data['profileImage'] ?? data['avatar'] ?? '').toString();

        fullName.value = name.isNotEmpty ? name : LocalStorage.myName;
        email.value = mail.isNotEmpty ? mail : LocalStorage.myEmail;
        phone.value = mobile;
        address.value = addr;

        if (rawImage.isNotEmpty) {
          // Build absolute url if needed
          if (rawImage.startsWith('http')) {
            profileImageUrl.value = rawImage;
          } else {
            profileImageUrl.value = '${AppUrls.imageUrl}$rawImage';
          }
        }

        // Keep local storage in sync
        await LocalStorage.setString(LocalStorageKeys.myName, fullName.value);
        await LocalStorage.setString(LocalStorageKeys.myEmail, email.value);
        await LocalStorage.setString(LocalStorageKeys.myProfileImage, profileImageUrl.value);
        await LocalStorage.getAllPrefData();
      }
    } catch (e) {
      AppLogger.error('❌ fetchLatestProfile error: $e', error: 'fetchLatestProfile error: $e');
    } finally {
      isFetching.value = false;
    }
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
      // Don't clean the phone number here as it's already formatted by the IntlPhoneField
      final success = await _service.updateProfile(
        name,
        mail,
        mobile, // This should already be in the correct format with country code
        addr,
        imageFile.value,
      );

      if (success) {
        await LocalStorage.setString(LocalStorageKeys.myName, name);
        await LocalStorage.setString(LocalStorageKeys.myEmail, mail);
        await LocalStorage.setString(LocalStorageKeys.phone, phone.value);
        await fetchLatestProfile(); // refresh data including image url
        await LocalStorage.getAllPrefData();

        AppLogger.info('✅ Profile updated & LocalStorage synced');
        Get.back(result: true); // return to Profile and trigger refresh
        Get.snackbar('Success', 'Profile updated successfully!');
      } else {
        AppLogger.error('❌ Update failed on server side', error: 'Update failed on server side');
        Get.snackbar('Error', 'Failed to update profile. Try again later.');
      }
    } catch (e) {
      AppLogger.error('❗ Exception: $e', error: 'Exception: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}