import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/profile/controllers/language_view_controller.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LanguageView extends GetView<LanguageViewController> {
  const LanguageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.language,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          spacing: AppSize.height(height: 2.0),
          children: [
            Obx(
              () => Container(
                padding: EdgeInsets.only(left: AppSize.height(height: 2.0)),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    AppText(
                      title: AppStaticKey.english,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: AppColors.gray),
                    ),
                    const Spacer(),
                    Radio(
                      activeColor: AppColors.primary,
                      value: "english",
                      groupValue: controller.selectedLanguage.value,
                      onChanged: (value) {
                        controller.selectedLanguage.value = "english";
                      },
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.only(left: AppSize.height(height: 2.0)),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    AppText(
                      title: AppStaticKey.french,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: AppColors.gray),
                    ),
                    const Spacer(),
                    Radio(
                      activeColor: AppColors.primary,
                      value: "french",
                      groupValue: controller.selectedLanguage.value,
                      onChanged: (value) {
                        controller.selectedLanguage.value = "french";
                      },
                    ),
                  ],
                ),
              ),
            ),
            AppCommonButton(
              onPressed: () {
                controller.changeLanguage();
              },
              title: AppStaticKey.continued,
              fontSize: AppSize.height(height: 1.70),
            ),
          ],
        ),
      ),
    );
  }
}
