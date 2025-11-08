import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/storage_keys.dart';
import '../../../data/local/storage_service.dart';
import '../../../localization/app_static_key.dart';

class LanguageViewController extends GetxController {
  RxString selectedLanguage = "english".obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved language preference
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    final savedLang = await LocalStorage.getString(LocalStorageKeys.language);
    if (savedLang.isNotEmpty) {
      selectedLanguage.value = savedLang;
    } else {
      // Default to current locale
      final currentLocale = Get.locale;
      if (currentLocale?.languageCode == 'fr') {
        selectedLanguage.value = 'french';
      } else {
        selectedLanguage.value = 'english';
      }
    }
  }

  Future<void> changeLanguage() async {
    Locale newLocale;
    
    if (selectedLanguage.value == 'french') {
      newLocale = const Locale('fr', 'FR');
    } else {
      newLocale = const Locale('en', 'US');
    }

    // Update the app locale
    await Get.updateLocale(newLocale);
    
    // Save language preference
    await LocalStorage.setString(
      LocalStorageKeys.language,
      selectedLanguage.value,
    );

    // Show success message
    final langName = selectedLanguage.value == "french" ? "Français" : "English";
    Get.snackbar(
      AppStaticKey.languageChanged.tr,
      '${AppStaticKey.languageChangedTo.tr} $langName',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    // Go back to previous screen
    Get.back();
  }
}