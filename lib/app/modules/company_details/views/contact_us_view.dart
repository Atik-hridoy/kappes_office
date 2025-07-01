import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ContactUsView extends GetView {
  const ContactUsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: AppSize.height(height: 1.0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSize.height(height: 1.5)),
            Row(
              spacing: AppSize.width(width: 1.0),
              children: [
                ImageIcon(
                  AssetImage(AppIcons.phone),
                  size: AppSize.height(height: 2.0),
                ),
                AppText(
                  title: "+1 (416) 555-1234",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              spacing: AppSize.width(width: 1.0),
              children: [
                Icon(Icons.email_outlined, size: AppSize.height(height: 2.0)),
                // ImageIcon(AssetImage(AppIcons.), size: AppSize.height(height: 2.0),),
                AppText(
                  title: "contact@techgear.com",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              spacing: AppSize.width(width: 1.0),
              children: [
                ImageIcon(
                  AssetImage(AppIcons.marker),
                  size: AppSize.height(height: 2.0),
                ),
                AppText(
                  title: "Toronto, Ontario, Canada",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              spacing: AppSize.width(width: 1.0),
              children: [
                ImageIcon(
                  AssetImage(AppIcons.networkIcon),
                  size: AppSize.height(height: 2.0),
                ),
                AppText(
                  title: "www.techgear.com",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            /// send message
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.sendUseMessage,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: AppStaticKey.enterYourFullName,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: AppStaticKey.enterYourEmail,
              ),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: AppStaticKey.enterYourMessage,
              ),
            ),
            SizedBox(height: AppSize.height(height: 1.0)),
            Align(
              alignment: Alignment.center,
              child: AppCommonButton(
                onPressed: () {},
                width: AppSize.width(width: 24.0),
                height: AppSize.height(height: 5.0),
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(AppSize.height(height: 0.5)),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: AppColors.white),
                title: AppStaticKey.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
