import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_button/quantity_button.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/tipple.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_cart_controller.dart';

class MyCartView extends GetView<MyCartController> {
  const MyCartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.myCart,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.height(height: 2.0)),
        child: ListView.separated(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGray),
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 1.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.width(width: 2.0),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 0.5),
                    ),
                    child: AppImage(
                      imagePath: AppImages.banner2,
                      height: AppSize.height(height: 9.0),
                      width: AppSize.height(height: 9.0),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSize.height(height: 1.0),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            AppText(
                              title: "Hiking Traveler Backpack",
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(letterSpacing: 0.0),
                            ),
                            Spacer(),
                            Tipple(
                              onTap: () {
                                // AppUtils.appLog("Hello world!");
                              },
                              height: AppSize.height(height: 5.0),
                              width: AppSize.height(height: 5.0),
                              borderRadius: BorderRadius.circular(
                                AppSize.height(height: 100.0),
                              ),
                              positionTop: -10,
                              positionRight: -11,
                              child: ImageIcon(
                                AssetImage(AppIcons.cancel),
                                size: AppSize.height(height: 2.2),
                              ),
                            ),
                          ],
                        ),
                        AppText(
                          title: "Size: M     Color: Yellow",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Row(
                          children: [
                            AppText(
                              title: "\$149.99",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Spacer(),
                            QuantityButton(
                              buttonSize: 1.5,
                              buttonCircularSize: 2.0,
                              spacing: 3.5,
                              textSize: AppSize.height(height: 1.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: AppSize.height(height: 2.0));
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.height(height: 2.0)),
            topRight: Radius.circular(AppSize.height(height: 2.0)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSize.height(height: 2.0),
            right: AppSize.height(height: 2.0),
            top: AppSize.height(height: 2.0),
            bottom: AppSize.height(height: 7.0),
          ),
          child: AppCommonButton(
            onPressed: () {
              Get.toNamed(Routes.checkoutView);
            },
            title: "${AppStaticKey.checkout} : \$449.97",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: AppSize.height(height: 2.0),
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
