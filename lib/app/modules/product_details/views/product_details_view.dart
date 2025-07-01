import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/product_details/widgets/color_palette.dart';
import 'package:canuck_mall/app/modules/product_details/widgets/product_size_selector.dart';
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
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.productDetails,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          Tipple(
            onTap: () {
              // AppUtils.appLog("Hello world!");
            },
            height: AppSize.height(height: 5.0),
            width: AppSize.height(height: 5.0),
            borderRadius: BorderRadius.circular(AppSize.height(height: 100.0)),
            positionTop: -8,
            positionRight: -10,
            child: ImageIcon(
              AssetImage(AppIcons.share),
              size: AppSize.height(height: 3.0),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(
          horizontal: AppSize.height(height: 2.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.height(height: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 1.5),
                    ),
                    child: AppImage(
                      imagePath: AppImages.banner3,
                      width: double.maxFinite,
                      height: AppSize.height(height: 40.0),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: AppSize.height(height: 1.5),
                    right: AppSize.width(width: 2.0),
                    child: Obx(
                      () => InkWell(
                        onTap: () {
                          controller.isFavourite.value =
                              !controller.isFavourite.value;
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSize.height(height: 0.5)),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              AppSize.height(height: 100.0),
                            ),
                          ),
                          child:
                              controller.isFavourite.value
                                  ? Icon(
                                    Icons.favorite_outlined,
                                    size: AppSize.height(height: 2.5),
                                    color: AppColors.lightRed,
                                  )
                                  : Icon(
                                    Icons.favorite_border,
                                    size: AppSize.height(height: 2.5),
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.5)),
              AppText(
                title: "Hiking Traveler Backpack",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.reviews);
                },
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,

                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: AppSize.height(height: 2.5),
                    ),
                    SizedBox(width: AppSize.width(width: 0.5)),
                    RichText(
                      text: TextSpan(
                        text: "4.9",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: " (320)",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              Row(
                spacing: AppSize.width(width: 2.0),
                children: [
                  AppText(
                    title: "\$149.99",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: AppSize.height(height: 2.0),
                      color: AppColors.primary,
                    ),
                  ),
                  AppText(
                    title: "\$159.99",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: AppSize.height(height: 2.0),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.grey.shade500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),

              /// shop
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 100.0),
                    ),
                    child: AppImage(
                      imagePath: AppImages.shopLogo,
                      height: AppSize.height(height: 5.5),
                      width: AppSize.height(height: 5.5),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title: "Peak",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AppText(
                        title: "Canada",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.store);
                    },
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 0.5),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSize.height(height: 0.8)),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          AppSize.height(height: 0.5),
                        ),
                      ),
                      child: AppText(
                        title: AppStaticKey.visitStore,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.white,
                          fontSize: AppSize.height(height: 1.50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),

              /// description
              AppText(
                title: AppStaticKey.description,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              AppText(
                title:
                    """Premium graphic tee featuring original artwork on 100% organic cotton. Pre-shrunk fabric with reinforced stitching for durability.
• 100% organic cotton
• Screen-printed design
• Made in Canada""",
                maxLine: 500,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),

              /// color
              AppText(
                title: "${AppStaticKey.color}:",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Obx(
                () => Row(
                  spacing: AppSize.width(width: 3.0),
                  children: [
                    ColorPalette(
                      onChanged: (value) {
                        controller.selectColor.value = value;
                      },
                      value: "white",
                      group: controller.selectColor.value,
                      color: AppColors.white,
                    ),
                    ColorPalette(
                      onChanged: (value) {
                        controller.selectColor.value = value;
                      },
                      value: "gray",
                      group: controller.selectColor.value,
                      color: AppColors.gray,
                    ),
                    ColorPalette(
                      onChanged: (value) {
                        controller.selectColor.value = value;
                      },
                      value: "green",
                      group: controller.selectColor.value,
                      color: AppColors.green,
                    ),
                    ColorPalette(
                      onChanged: (value) {
                        controller.selectColor.value = value;
                      },
                      value: "red",
                      group: controller.selectColor.value,
                      color: AppColors.lightRed,
                    ),
                    ColorPalette(
                      onChanged: (value) {
                        controller.selectColor.value = value;
                      },
                      value: "amber",
                      group: controller.selectColor.value,
                      color: AppColors.amber,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(height: 3.0)),

              /// size
              AppText(
                title: "${AppStaticKey.size}:",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Obx(
                () => Row(
                  spacing: AppSize.width(width: 3.0),
                  children: [
                    ProductSizeSelector(
                      value: "S",
                      group: controller.selectedProductSize.value,
                      onChanged: (value) {
                        controller.selectedProductSize.value = value;
                      },
                    ),
                    ProductSizeSelector(
                      value: "M",
                      group: controller.selectedProductSize.value,
                      onChanged: (value) {
                        controller.selectedProductSize.value = value;
                      },
                    ),
                    ProductSizeSelector(
                      value: "L",
                      group: controller.selectedProductSize.value,
                      onChanged: (value) {
                        controller.selectedProductSize.value = value;
                      },
                    ),
                    ProductSizeSelector(
                      value: "XL",
                      group: controller.selectedProductSize.value,
                      onChanged: (value) {
                        controller.selectedProductSize.value = value;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),

              /// quantity
              AppText(
                title: "${AppStaticKey.quantity}:",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              QuantityButton(),
              SizedBox(height: AppSize.height(height: 0.5)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),
            ],
          ),
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
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCommonButton(
                onPressed: () {},
                title: AppStaticKey.sendMessageToSeller,
                backgroundColor: AppColors.white,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Row(
                spacing: AppSize.width(width: 3.0),
                children: [
                  Flexible(
                    child: AppCommonButton(
                      onPressed: () {},
                      title: AppStaticKey.addToCart,
                      backgroundColor: AppColors.white200,
                      borderColor: AppColors.lightGray,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: AppSize.height(height: 2.0),
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Flexible(
                    child: AppCommonButton(
                      onPressed: () {
                        Get.toNamed(Routes.myCart);
                      },
                      title: AppStaticKey.buyNow,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: AppSize.height(height: 2.0),
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
