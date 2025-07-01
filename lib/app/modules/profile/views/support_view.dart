import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SupportView extends GetView {
  const SupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.helpAndSupport,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0),),
        child: Column(
          spacing: AppSize.height(height: 2.0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.lightGray, // Set your desired border color here
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 1.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.height(height: 1.0)), // Optional: internal padding
                child: ListTile(
                  leading: AppImage(
                    imagePath: AppIcons.supportPhone,
                    height: AppSize.height(height: 5.0),
                    width: AppSize.height(height: 5.0),
                  ),
                  title: AppText(
                    title: AppStaticKey.phone,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: AppText(
                    title: "+966-50-9876543",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.lightGray, // Customize border color as needed
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 1.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0), // Optional padding
                child: ListTile(
                  leading: AppImage(
                    imagePath: AppIcons.supportMail,
                    height: AppSize.height(height: 5.0),
                    width: AppSize.height(height: 5.0),
                  ),
                  title: AppText(
                    title: AppStaticKey.emailAddress,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: AppText(
                    title: "osama@demo.com",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray,
                    ),
                  ),
                ),
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}
