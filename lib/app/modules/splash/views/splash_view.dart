import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/constants/app_logo.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.splashScreen),
            fit: BoxFit.cover,
          ),
        ),
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        child: Obx(
          () => AnimatedOpacity(
            opacity: controller.opacity.value,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            child: AppImage(
              imagePath: AppLogo.primaryLogo,
              height: AppSize.height(height: 18.0),
              width: AppSize.height(height: 18.0),
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error, color: AppColors.error),
            ),
          ),
        ),
      ),
    );
  }
}
