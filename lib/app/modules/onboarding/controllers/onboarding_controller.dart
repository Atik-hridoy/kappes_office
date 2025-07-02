import 'dart:async';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  PageController pageController = PageController();
  RxInt pageIndex = 0.obs;
  late Timer _timer;

  void scrollPageView() {
    try {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (pageController.page == 2) {
          pageIndex.value = 0;
          pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        } else {
          pageIndex++;
          pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      });
    } catch (e, stackTrace) {
      AppUtils.appError("error comes from : $e\n$stackTrace");
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));
      scrollPageView();
    });
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    _timer.cancel();
    super.onClose();
  }
}
