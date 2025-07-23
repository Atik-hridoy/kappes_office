import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CustomProductOrderCard extends StatelessWidget {
  // Add a constructor to accept an Order object
  final Order order;
  const CustomProductOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // For simplicity, let's assume the first product in the order for display image/name.
    // You might want to loop through order.products if displaying multiple items per card.
    final product = order.products.isNotEmpty ? order.products.first : null;

    return Container(
      padding: EdgeInsets.all(AppSize.height(height: 1.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Using Row with children for spacing instead of 'spacing' property if it's not supported by your 'Row' setup
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.height(height: 0.5)),
            child: AppImage(
              // Use dynamic image URL from the product, if available
              imagePath:
                  product?.product.images ??
                  AppImages.product1, // Fallback to a default image
              height: AppSize.height(height: 10.0),
              width: AppSize.height(height: 10.0),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: AppSize.width(width: 2.0)), // Manual spacing
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  title: product?.product.name ?? "N/A", // Dynamic Product Name
                  maxLine: 2, // Keep max line reasonable for product name
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                ),
                if (product?.variant != null && product!.variant.isNotEmpty)
                  AppText(
                    title:
                        "Variant: ${product.variant}", // Dynamic Product Variant
                    maxLine: 1,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.gray,
                    ), // Slightly lighter color for variant
                  ),
                SizedBox(height: AppSize.height(height: 0.5)), // Adjust spacing
                AppText(
                  title:
                      "Quantity: ${product?.quantity ?? 1}", // Dynamic Quantity
                  maxLine: 1,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: AppColors.darkGray),
                ),
                SizedBox(height: AppSize.height(height: 1.0)), // Adjust spacing
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      title:
                          "\$${(product?.unitPrice ?? 0.0).toStringAsFixed(2)}", // Dynamic Unit Price
                      maxLine: 1,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    AppCommonButton(
                      onPressed: () {
                        // TODO: Implement navigation to order details or product details
                        print('View details for Order ID: ${order.id}');
                      },
                      width: AppSize.width(width: 27.0),
                      height: AppSize.height(height: 4.0),
                      title: AppStaticKey.viewDetails,
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 0.8),
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: AppColors.white),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
