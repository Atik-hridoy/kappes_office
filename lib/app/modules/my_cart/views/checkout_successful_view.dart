import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutSuccessfulView extends GetView {
  const CheckoutSuccessfulView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.checkout,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: AppSize.height(height: 5.0)),
            Container(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 100.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 100.0),
                  ),
                ),
                child: ImageIcon(
                  AssetImage(AppIcons.done),
                  color: AppColors.white,
                  size: AppSize.height(height: 5.0),
                ),
              ),
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.thankYouForYourOrder,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: AppSize.height(height: 2.80),
              ),
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title:
                  AppStaticKey
                      .yourOrderIsBeingProcessedAndWillBeShippedShortlyWeAreExcitedToGetYourItemsToYou,
              maxLine: 5,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppCommonButton(
              onPressed: () {
                Get.toNamed(Routes.myOrders);
              },
              title: AppStaticKey.myOrder,
              fontSize: AppSize.height(height: 2.0),
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppCommonButton(
              onPressed: () {
                Get.until((route) => route.isFirst);
              },
              title: AppStaticKey.home,
              backgroundColor: AppColors.white,
              borderColor: AppColors.lightGray,
              color: AppColors.black,
              fontSize: AppSize.height(height: 2.0),
            ),
          ],
        ),
      ),
    );
  }
}
