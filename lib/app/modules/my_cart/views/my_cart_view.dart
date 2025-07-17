import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';

import '../../../constants/app_images.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_button/quantity_button.dart';
import '../controllers/my_cart_controller.dart';

class MyCartView extends GetView<MyCartController> {
  const MyCartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: "My Cart",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.height(height: 2.0)),
        child: Obx(
              () {
            // Check if the cart is empty
            if (controller.cartItems.isEmpty) {
              return Center(child: Text('No items in cart.'));
            }

            return ListView.separated(
              itemCount: controller.cartItems.length.toInt(),
              itemBuilder: (context, index) {
                var item = controller.cartItems[index];
                return Container(
                  padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray),
                    borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.height(height: 0.5)),
                        child: AppImage(
                          imagePath: item['logo'] ?? AppImages.banner2,  // Use the logo or a placeholder
                          height: AppSize.height(height: 9.0),
                          width: AppSize.height(height: 9.0),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: AppSize.height(height: 1.0)),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // spacing: AppSize.height(height: 1.0), // Remove if not using a custom Column with spacing property
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                AppText(
                                  title: item['name'] ?? 'Unknown Item',  // Fallback if name is missing
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(letterSpacing: 0.0),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    // Handle remove item from cart
                                  },
                                ),
                              ],
                            ),
                            AppText(
                              title: "Size: ${item['size'] ?? 'M'}     Color: ${item['color'] ?? 'Yellow'}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              children: [
                                AppText(
                                  title: "\$${item['price'] ?? 0.0}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Spacer(),
                                QuantityButton(
                                  buttonSize: 1.5,
                                  buttonCircularSize: 2.0,
                                  spacing: 3.5,
                                  textSize: AppSize.height(height: 1.5),
                                  onChanged: (newQuantity) {
                                    // Handle quantity update
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
              separatorBuilder: (context, index) {
                return SizedBox(height: AppSize.height(height: 2.0));
              },
            );
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
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 2), // changes position of shadow
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
              Get.toNamed(Routes.checkoutView);  // Navigate to checkout view
            },
            title: "Checkout: \$${controller.totalAmount.value}",
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
