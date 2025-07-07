import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxDouble opacity = 0.0.obs;

  Future<void> onInitialPage() async {
    ///  Make status bar transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    ///
    Future.delayed(const Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });
    Future.delayed(const Duration(seconds: 3), () {
     if(LocalStorage.token.isNotEmpty){
        Get.offAllNamed(Routes.home);
      }else{
        Get.offAllNamed(Routes.onboarding);
     }
    });
  }

  @override
  void onInit() {
    onInitialPage();
    super.onInit();
  }
}
