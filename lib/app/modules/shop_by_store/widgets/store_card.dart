import 'package:flutter/material.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';

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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.height(height: 1.9)),
            child: shopCover.isNotEmpty
                ? AppImage(
                    imagePath: shopCover,
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                    height: AppSize.height(height: 25.0),
                  )
                : Image.asset(
                    'assets/images/placeholder_cover.png',
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                    height: AppSize.height(height: 25.0),
                  ),
          ),

          // White rounded bottom overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: AppSize.height(height: 11.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSize.height(height: 1.9)),
                  bottomRight: Radius.circular(AppSize.height(height: 1.9)),
                ),
              ),
            ),
          ),

          // Logo + Texts
          Positioned(
            bottom: AppSize.height(height: 2.2),
            left: AppSize.height(height: 1.5),  // Reduced left padding
            right: AppSize.height(height: 1.5), // Reduced right padding
            child: LayoutBuilder(
              builder: (context, constraints) {
                final logoSize = constraints.maxWidth * 0.25; // Make logo size relative to available width
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Elevated square logo
                    Container(
                      height: logoSize,
                      width: logoSize,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.height(height: 0.8)),
                    child: shopLogo.isNotEmpty
                        ? AppImage(
                            imagePath: shopLogo,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Image.asset(
                            'assets/images/placeholder_logo.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                    SizedBox(width: constraints.maxWidth * 0.03), // Make spacing relative to available width
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            title: shopName,
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: AppSize.height(height: 2.0),
                                  letterSpacing: 0,
                                ),
                          ),
                          SizedBox(height: AppSize.height(height: 0.8)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: AppSize.height(height: 2.0),
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: AppSize.width(width: 1.2)),
                              Expanded(
                                child: Text(
                                  address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade700,
                                        fontSize: AppSize.height(height: 1.6),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
