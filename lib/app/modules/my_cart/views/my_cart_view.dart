import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
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

import '../../../constants/app_urls.dart';
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = controller.cartData.value?.data?.items ?? [];

        if (items.isEmpty) {
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
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 0.5),
                      ),
                      child: Image.network(
                        imageUrl,
                        height: AppSize.height(height: 9.0),
                        width: AppSize.height(height: 9.0),
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Image.asset(
                              AppImages.banner2,
                              height: AppSize.height(height: 9.0),
                              width: AppSize.height(height: 9.0),
                              fit: BoxFit.cover,
                            ),
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
                                child: ImageIcon(
                                  AssetImage(AppIcons.cancel),
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
                                title:
                                    "\$${item.totalPrice.toStringAsFixed(2)}",
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
              );
            },
            separatorBuilder:
                (context, index) =>
                    SizedBox(height: AppSize.height(height: 2.0)),
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
}
