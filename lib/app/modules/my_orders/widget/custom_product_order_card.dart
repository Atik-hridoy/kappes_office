import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart';

class CustomProductOrderCard extends StatelessWidget {
  final OrderResult order;
  const CustomProductOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.height(height: 1.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSize.width(width: 2.0),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.height(height: 0.5)),
            child: AppImage(
              imagePath:
  (order.products.isNotEmpty &&
          order.products[0].product.images.isNotEmpty)
      ? (order.products[0].product.images[0].startsWith('http')
          ? order.products[0].product.images[0]
          : AppUrls.imageUrl + order.products[0].product.images[0])
      : AppImages.product1,
              height: AppSize.height(height: 10.0),
              width: AppSize.height(height: 10.0),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: AppColors.error);
              },
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  title:
                      order.products.isNotEmpty
                          ? order.products[0].product.name
                          : '',
                  maxLine: 5,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                ),
                AppText(
                  title: order.status, // status is non-nullable
                  maxLine: 5,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: AppSize.height(height: 2.0)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      title:
                          order.products.isNotEmpty
                              ? '\$${order.products[0].unitPrice.toStringAsFixed(2)}'
                              : '',
                      maxLine: 5,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Spacer(),
                    AppCommonButton(
                      onPressed: () {},
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
