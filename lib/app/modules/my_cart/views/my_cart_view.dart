//import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_button/quantity_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/tipple.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/my_cart_controller.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyCartController());

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.myCart,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final items = controller.cartData.value?.data?.items;

        // Show shimmer only on initial load when there's no data
        if (controller.isLoading.value && (items == null || items.isEmpty)) {
          return _buildShimmerEffect();
        }

        // If we have no items (not just loading), show empty state
        if (items == null || items.isEmpty) {
          return Center(
            child: AppText(
              title: "Your cart is empty",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.height(height: 2.0),
          ),
          child: ListView.separated(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.productId;
              final variant = item.variantId;

              final imageUrl = controller.getFullImageUrl(
                product?.images?.first,
              );

              return AnimatedScale(
                duration: Duration(milliseconds: 300),
                scale: controller.isLoading.value ? 0.95 : 1.0,
                child: Card(
                  elevation: 5,  // Material Design Elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.productDetails, arguments: product?.id);
                    },
                    borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image + Heart Icon
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
                            child: Image.network(
                              imageUrl,
                              height: AppSize.height(height: 9.0),
                              width: AppSize.height(height: 9.0),
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: AppSize.height(height: 9.0),
                                  width: AppSize.height(height: 9.0),
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: AppSize.height(height: 9.0),
                                  width: AppSize.height(height: 9.0),
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported_outlined),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: AppSize.width(width: 2.0)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        title: product?.name ?? "Product Name",
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                    ),
                                    Tipple(
                                      onTap: () {
                                        controller.removeCartItem(product?.id ?? '');
                                      },
                                      height: AppSize.height(height: 5.0),
                                      width: AppSize.height(height: 5.0),
                                      borderRadius: BorderRadius.circular(
                                        AppSize.height(height: 100.0),
                                      ),
                                      positionTop: -10,
                                      positionRight: -11,
                                      child: Icon(
                                        Icons.cancel,
                                        size: AppSize.height(height: 2.2),
                                      ),
                                    ),
                                  ],
                                ),
                                AppText(
                                  title:
                                      "Size: ${variant?.storage ?? '-'} | Color: ${variant?.colorName ?? '-'}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Row(
                                  children: [
                                    AppText(
                                      title: "\$${item.totalPrice.toStringAsFixed(2)}",
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    Spacer(),
                                    QuantityButton(
                                      buttonSize: 1.5,
                                      buttonCircularSize: 2.0,
                                      spacing: 3.5,
                                      textSize: AppSize.height(height: 1.5),
                                      onChanged: (newQuantity) {
                                        controller.updateQuantity(index, newQuantity);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: AppSize.height(height: 2.0)),
          ),
        );
      }),

      bottomNavigationBar: Obx(() {
        double total = controller.cartTotalPrice;

        return Container(
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
                offset: const Offset(0, 2),
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
              onPressed: controller.goToCheckout,
              title: "${AppStaticKey.checkout} : \$${total.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: AppSize.height(height: 2.0),
                color: AppColors.white,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.height(height: 2.0),
        vertical: AppSize.height(height: 1.0),
      ),
      cacheExtent: 1000,
      itemCount: 3, // Show 3 skeleton items
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppSize.height(height: 2.0)),
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSize.height(height: 9.0),
                  height: AppSize.height(height: 9.0),
                  color: Colors.white,
                ),
                SizedBox(width: AppSize.width(width: 2.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: AppSize.height(height: 2.0),
                        color: Colors.white,
                      ),
                      SizedBox(height: AppSize.height(height: 1.0)),
                      Container(
                        width: double.infinity,
                        height: AppSize.height(height: 1.5),
                        color: Colors.white,
                      ),
                      SizedBox(height: AppSize.height(height: 1.0)),
                      Row(
                        children: [
                          Container(
                            width: AppSize.height(height: 6.0),
                            height: AppSize.height(height: 2.0),
                            color: Colors.white,
                          ),
                          Spacer(),
                          Container(
                            width: AppSize.height(height: 10.0),
                            height: AppSize.height(height: 3.0),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
