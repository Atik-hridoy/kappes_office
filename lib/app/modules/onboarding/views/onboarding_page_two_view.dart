import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class OnboardingPageTwoView extends GetView {
  const OnboardingPageTwoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppImage(
            imagePath: AppImages.onboard2,
            width: double.maxFinite,
            height: AppSize.height(height: 60.0),
            fit: BoxFit.cover,
          ),
          SizedBox(height: AppSize.height(height: 3.0)),
          SizedBox(
            width: AppSize.width(width: 60.0),
            child: AppText(
              title: AppStaticKey.browseShopAndEarnRewards,
              maxLine: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(height: AppSize.height(height: 2.0)),
          SizedBox(
            width: AppSize.width(width: 89.0),
            child: AppText(
              title: AppStaticKey.onboardTwoDescription,
              maxLine: 5,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
