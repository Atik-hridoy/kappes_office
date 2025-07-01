import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

class ProfileWithBadge extends StatelessWidget {
  final VoidCallback onPressed;
  final ImageProvider<Object>? imageUrl;
  final Color badgeColor;
  final double size;
  final double badgeSize;

  const ProfileWithBadge({
    super.key,
    required this.imageUrl,
    this.badgeColor = AppColors.primary,
    this.size = 115,
    this.badgeSize = 35.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSize.height(height: 100.0)),
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Circular profile image
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageUrl ?? const AssetImage(AppImages.profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Badge in bottom right corner
          Positioned(
            bottom: AppSize.width(width: 2.0),
            right: AppSize.width(width: 2.0),
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.white,
                  size: AppSize.height(height: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
