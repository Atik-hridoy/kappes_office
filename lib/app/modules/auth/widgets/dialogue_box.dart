import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogueBox extends StatelessWidget {
  const DialogueBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.height(height: 3.0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage(
            imagePath: AppImages.vectorImage,
            height: AppSize.height(height: 7.0),
            width: AppSize.height(height: 7.0),
          ),
          SizedBox(height: AppSize.height(height: 2.0)),
          Text(
            AppStaticKey.passwordChanged,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.primary,
              fontSize: AppSize.height(height: 1.80),
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: AppSize.height(height: 1.0)),
          Text(
            AppStaticKey.yourCanNowUseYourNewPasswordToLoginToYourAccount.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: AppSize.height(height: 2.0)),
          AppCommonButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(Routes.login);
            },
            title: AppStaticKey.login,
            height: AppSize.height(height: 6),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
