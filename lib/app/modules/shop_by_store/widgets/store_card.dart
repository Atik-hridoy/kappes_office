import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final String shopLogo;
  final String shopCover;
  final String shopName;
  final String address;
  const StoreCard(
      {
    super.key,
    required this.shopLogo,
    required this.shopCover,
    required this.shopName,
    required this.address
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Allow content to overflow
        children: [
          // Cover image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.height(height: 1.9)),
            child: AppImage(
              imagePath: shopCover,
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: AppSize.height(height: 25.0),
            ),
          ),

          // curve background
          Positioned(
            bottom: 0.0,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: AppSize.height(height: 10.5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSize.height(height: 1.9)),
                  bottomRight: Radius.circular(AppSize.height(height: 1.9)),
                ),
              ),
            ),
          ),

          // store header section
          Positioned(
            bottom: AppSize.height(height: 2.2),
            left: AppSize.height(height: 3.0),
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: AppSize.width(width: 2.0),
              children: [
                Container(
                  height: AppSize.height(height: 13.0),
                  width: AppSize.height(height: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 1.5),
                    ),
                    border: Border.all(color: AppColors.white),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 1.5),
                    ),
                    child: AppImage(
                      imagePath: shopLogo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: shopName,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: AppSize.height(height: 2.0),
                      ),
                    ),
                    SizedBox(height: AppSize.height(height: 1.0)),
                    Row(
                      spacing: AppSize.width(width: 1.0),
                      children: [
                        ImageIcon(
                          AssetImage(AppIcons.marker),
                          size: AppSize.height(height: 2.0),
                        ),
                        Text(
                          address,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 1.0)),
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