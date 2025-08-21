import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Coupon extends StatelessWidget {
  const Coupon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.coupon),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(AppSize.height(height: 2.0))
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 1.5)),
        child: Column(
          spacing: AppSize.height(height: 0.5),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.width(width: 1.0),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 0.5),
                  ),
                  child: AppImage(
                    imagePath: AppImages.shopLogo,
                    height: AppSize.height(height: 5.0),
                    width: AppSize.height(height: 5.0),
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: AppColors.error);
                    },
                  ),
                ),
                Column(
                  spacing: AppSize.height(height: 0.5),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: "Peak Apparel",
                      style: Theme.of(context).textTheme.bodySmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      spacing: AppSize.width(width: 1.0),
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: AppSize.height(height: 2.0),
                        ),
                        AppText(
                          title: "Expired  10 May, 2025",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            AppText(
              title: "25% Off promo code ",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: AppSize.height(height: 2.0),
                fontWeight: FontWeight.w700,
              ),
            ),
            AppText(
              title: "Maximum discount up to  \$5",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            InkWell(
              onTap: () {},
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  AppText(
                    title: AppStaticKey.copy,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ImageIcon(
                    AssetImage(AppIcons.copyIcon),
                    size: AppSize.height(height: 2.0),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
