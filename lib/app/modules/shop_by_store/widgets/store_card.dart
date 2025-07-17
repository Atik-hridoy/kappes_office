import 'package:flutter/material.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/constants/app_icons.dart';

class StoreCard extends StatelessWidget {
  final String shopLogo;
  final String shopCover;
  final String shopName;
  final String address;

  const StoreCard({
    super.key,
    required this.shopLogo,
    required this.shopCover,
    required this.shopName,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // For responsiveness

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Allow content to overflow
        children: [
          // Cover image (with fallback)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.height(height: 1.9)),
            child: shopCover != null && shopCover.isNotEmpty
                ? AppImage(
              imagePath: shopCover,
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: AppSize.height(height: 25.0), // Set height for cover photo
            )
                : Image.asset(
              'assets/images/placeholder_cover.png', // Default placeholder
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: AppSize.height(height: 25.0),
            ),
          ),

          // Curve background to overlay the cover image
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

          // Store header section (logo and name)
          Positioned(
            bottom: AppSize.height(height: 2.2),
            left: AppSize.height(height: 3.0),
            right: AppSize.height(height: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Shop Logo (with fallback)
                Container(
                  height: AppSize.height(height: 13.0),
                  width: AppSize.height(height: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
                    border: Border.all(color: AppColors.white),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
                    child: shopLogo != null && shopLogo.isNotEmpty
                        ? AppImage(
                      imagePath: shopLogo,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/images/placeholder_logo.png', // Default placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05), // Add spacing between logo and text
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
                      children: [
                        ImageIcon(
                          AssetImage(AppIcons.marker),
                          size: AppSize.height(height: 2.0),
                        ),
                        SizedBox(width: screenWidth * 0.02), // Responsive spacing
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(fontSize: AppSize.height(height: 1.5)),
                            overflow: TextOverflow.ellipsis, // Handle long address
                          ),
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
