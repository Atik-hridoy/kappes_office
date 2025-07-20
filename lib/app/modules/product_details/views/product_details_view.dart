import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
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
      body: Obx(() {
        final product = controller.product.value;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (product == null) {
          return const Center(child: Text('Product not found'));
        }

        // Use image URL directly if already normalized, else construct
        final imageUrl =
            product.images.isNotEmpty
                ? (product.images.first.startsWith('http')
                    ? product.images.first
                    : AppUrls.imageUrl + product.images.first)
                : AppImages.banner3;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.height(height: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 1.5),
                    ),
                    child: AppImage(
                      imagePath: imageUrl,
                      width: double.infinity,
                      height: AppSize.height(height: 40.0),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: AppSize.height(height: 1.5),
                    right: AppSize.width(width: 2.0),
                    child: InkWell(
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
                        child: Icon(
                          controller.isFavourite.value
                              ? Icons.favorite_outlined
                              : Icons.favorite_border,
                          size: AppSize.height(height: 2.5),
                          color:
                              controller.isFavourite.value
                                  ? AppColors.lightRed
                                  : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.5)),

              // Product Name
              AppText(
                title: product.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),

              // Rating & Reviews
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.reviews, arguments: product.id);
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
                        text: product.avgRating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: " (${product.totalReviews})",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),

              // Product Price
              Row(
                children: [
                  AppText(
                    title: "\$${product.basePrice.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: AppSize.height(height: 2.0),
                      color: AppColors.primary,
                    ),
                  ),
                  if (product.productVariantDetails.isNotEmpty) ...[
                    SizedBox(width: AppSize.width(width: 2.0)),
                    AppText(
                      title:
                          "\$${product.productVariantDetails[0].variantPrice.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppSize.height(height: 2.0),
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.0)),

              // Shop Details
              Divider(color: AppColors.lightGray),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 100.0),
                    ),
                    child: AppImage(
                      imagePath:
                          (product.shop.logo != null &&
                                  product.shop.logo.startsWith('http'))
                              ? product.shop.logo
                              : AppUrls.imageUrl + (product.shop.logo ?? ''),
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
                        title: product.shop.name ?? '',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AppText(
                        title: product.shop.address?.country ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      print(
                        '[ProductDetailsView] Navigating to store with ID: ${product.shop.id}',
                      );
                      Get.toNamed(
                        Routes.store,
                        arguments: product.shop.id,
                      ); // Pass store ID as arguments
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
                          fontSize: AppSize.height(height: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Divider(color: AppColors.lightGray),

              // Description
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
                title: product.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: AppSize.height(height: 1.0)),

              // Color Palette
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),
              AppText(
                title: "${AppStaticKey.color}:",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Obx(() {
                return Row(
                  children:
                      product.productVariantDetails.map((variant) {
                        String code = variant.variantId.color.code;
                        if (code.length == 7 && code.startsWith('#')) {
                          code = code.replaceFirst('#', '0xFF');
                        } else if (code.length == 9 && code.startsWith('#')) {
                          code = code.replaceFirst('#', '0x');
                        }
                        final color = Color(int.parse(code));
                        return Column(
                          children: [
                            ColorPalette(
                              onChanged: (value) {
                                controller.selectColor.value = value;
                              },
                              value: variant.variantId.color.name,
                              group: controller.selectColor.value,
                              color: color,
                            ),
                            SizedBox(height: AppSize.height(height: 0.5)),
                            AppText(
                              title:
                                  variant.variantId.color.name.isNotEmpty
                                      ? variant.variantId.color.name
                                      : code,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        );
                      }).toList(),
                );
              }),
              SizedBox(height: AppSize.height(height: 3.0)),

              // Size Selector (dynamically fetched)
              AppText(
                title: "${AppStaticKey.size}:",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Obx(() {
                return Row(
                  children:
                      product.productVariantDetails.map((variant) {
                        return ProductSizeSelector(
                          value: variant.variantId.size,
                          group: controller.selectedProductSize.value,
                          onChanged: (value) {
                            controller.selectedProductSize.value = value;
                          },
                        );
                      }).toList(),
                );
              }),
              SizedBox(height: AppSize.height(height: 1.0)),

              // Quantity Selector
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),
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
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.height(height: 2.0)),
            topRight: Radius.circular(AppSize.height(height: 2.0)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 8,
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
                children: [
                  Expanded(
                    child: AppCommonButton(
                      onPressed: () {
                        Get.toNamed(Routes.myCart);
                      },
                      title: AppStaticKey.addToCart,
                      backgroundColor: AppColors.white200,
                      borderColor: AppColors.lightGray,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: AppSize.height(height: 2.0),
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.width(width: 3.0)),
                  Expanded(
                    child: AppCommonButton(
                      onPressed: () {
                        Get.toNamed(Routes.checkoutView);
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
