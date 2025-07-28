// ignore_for_file: deprecated_member_use

import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            onTap: () {},
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

        final imageUrl =
            product.images.isNotEmpty
                ? (product.images.first.startsWith('http')
                    ? product.images.first
                    : AppUrls.imageUrl + product.images.first)
                : AppImages.banner3;

        final variants = product.productVariantDetails;
        final colors = variants.map((v) => v.variantId.color).toSet().toList();
        final sizes = variants.map((v) => v.variantId.size).toSet().toList();

        return SingleChildScrollView(
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
                      onTap: () => controller.toggleFavorite(),
                      child: Obx(
                        () => Container(
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
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.5)),

              AppText(
                title: product.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),

              InkWell(
                onTap: () {
                  Get.toNamed(Routes.reviews, arguments: product.id);
                },
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
              Divider(color: AppColors.lightGray),

              // Shop info skipped for brevity (you already had it fine)
              Divider(color: AppColors.lightGray),

              AppText(
                title: AppStaticKey.description,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              AppText(
                title: product.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: AppSize.height(height: 1.0)),

              if (colors.isNotEmpty) ...[
                Divider(color: AppColors.lightGray),
                AppText(
                  title: "${AppStaticKey.color}:",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: AppSize.height(height: 2.0),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Obx(
                  () => Row(
                    children:
                        colors.map((color) {
                          String code = color.code;
                          if (code.length == 7 && code.startsWith('#')) {
                            code = code.replaceFirst('#', '0xFF');
                          } else if (code.length == 9 && code.startsWith('#')) {
                            code = code.replaceFirst('#', '0x');
                          }
                          final colorValue = Color(int.parse(code));
                          return Padding(
                            padding: EdgeInsets.only(
                              right: AppSize.width(width: 2.0),
                            ),
                            child: Column(
                              children: [
                                ColorPalette(
                                  onChanged: (value) {
                                    controller.updateSelectedColor(value);
                                  },
                                  value: color.name,
                                  group: controller.selectColor.value,
                                  color: colorValue,
                                ),
                                SizedBox(height: AppSize.height(height: 0.5)),
                                AppText(
                                  title:
                                      color.name.isNotEmpty ? color.name : code,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],

              if (sizes.isNotEmpty) ...[
                AppText(
                  title: "${AppStaticKey.size}:",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: AppSize.height(height: 2.0),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Obx(
                  () => Wrap(
                    spacing: AppSize.width(width: 2.0),
                    children:
                        sizes.map((size) {
                          return ProductSizeSelector(
                            value: size,
                            group: controller.selectedProductSize.value,
                            onChanged: (value) {
                              controller.updateSelectedSize(value);
                            },
                          );
                        }).toList(),
                  ),
                ),
              ],

              Divider(color: AppColors.lightGray),
              AppText(
                title: "${AppStaticKey.quantity}:",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                ),
              ),
              QuantityButton(
                onChanged: (qty) => controller.selectedQuantity.value = qty,
              ),
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
                      onPressed: () async {
                        await controller.addProductToCart();
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
                        final productId = controller.product.value?.id ?? '';
                        final variantId = controller.selectedVariantId.value;
                        final qty = controller.selectedQuantity.value;
                        final shopId = controller.product.value?.shop.id ?? '';

                        if (productId.isEmpty || variantId.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please select product options',
                          );
                          return;
                        }

                        final price = controller.product.value?.basePrice ?? 0;
                        final totalPrice = price * qty;
                        final orderProduct = OrderProduct(
                          product: productId,
                          variant: variantId,
                          quantity: qty,
                        );

                        Get.toNamed(
                          Routes.checkoutView,
                          arguments: {
                            'shopId': shopId,
                            'products': [orderProduct],
                            'itemCost': totalPrice,
                            'productId': productId,
                          },
                        );
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
