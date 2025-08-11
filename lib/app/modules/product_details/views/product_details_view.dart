import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/modules/product_details/controllers/product_details_controller.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/tipple.dart';

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
                : '';

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

              // Shop info section
              SizedBox(height: AppSize.height(height: 1.0)),
              Padding(
                padding: EdgeInsets.only(bottom: AppSize.height(height: 1.0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 100.0),
                      ),
                      child: AppImage(
                        imagePath: AppUrls.imageUrl + product.shop.logo,
                        height: AppSize.height(height: 5.5),
                        width: AppSize.height(height: 5.5),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: AppSize.width(width: 2.0)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            title: product.shop.name,
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(fontWeight: FontWeight.w900),
                          ),
                          AppText(
                            title: product.shop.address.country,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    // Visit Store button
                    InkWell(
                      onTap: () {
                        AppLogger.info(
                          'Navigating to storeId: ${product.shop.id}',
                        );
                        Get.toNamed(Routes.store, arguments: product.shop.id);
                      },
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 0.5),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.height(height: 1.2),
                          vertical: AppSize.height(height: 0.8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppSize.height(height: 0.5),
                          ),
                        ),
                        child: AppText(
                          title: AppStaticKey.visitStore,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(
                            color: AppColors.white,
                            fontSize: AppSize.height(height: 1.5),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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

              // Chat with Seller Button
              AppCommonButton(
                onPressed: () {
                  // Create or navigate to chat using shop ID
                  final shopId = product.shop.id;
                  if (shopId.isNotEmpty) {
                    Get.toNamed(
                      Routes.chattingView,
                      arguments: {'chatId': shopId},
                    );
                  }
                },
                title: AppStaticKey.sendMessageToSeller,
                backgroundColor: AppColors.white,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  color: AppColors.primary,
                ),
              ),
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
              color: Colors.black.withValues(alpha: 0.1),
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
                onPressed: () {
                  controller.handleCreateChat(shopId: controller.product.value?.shop.id ?? '');
                },
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
                        controller.handleCheckoutFromDetails();
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
