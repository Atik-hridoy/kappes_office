import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/onboarding/views/onboarding_page_one_view.dart';
import 'package:canuck_mall/app/modules/onboarding/views/onboarding_page_three_view.dart';
import 'package:canuck_mall/app/modules/onboarding/views/onboarding_page_two_view.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              children: [
                OnboardingPageOneView(),
                OnboardingPageTwoView(),
                OnboardingPageThreeView(),
              ],
            ),
          ),
          SmoothPageIndicator(
              controller: controller.pageController,  // PageController
              count:  3,
              effect:  WormEffect(
                dotColor: AppColors.lightGray,
                activeDotColor: AppColors.black,
                dotWidth: AppSize.height(height: 1.5),
                dotHeight: AppSize.height(height: 1.5),
              ),  // your preferred effect
              onDotClicked: (index){
              }
          ),
          SizedBox(height: AppSize.height(height: 3.0),),
          AppCommonButton(
            onPressed: () {
              Get.offAllNamed(Routes.login);
            },
            title: AppStaticKey.singIn,
            width: AppSize.width(width: 80.0),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppSize.height(height: 1.5),),
          RichText(
            text: TextSpan(
              text: AppStaticKey.alreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                  recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      Get.offAllNamed(Routes.signUP);
                    },
                  text: AppStaticKey.signUp,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.height(height: 5.0)),
        ],
      ),
    );
  }
}
