import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:flutter/material.dart';

class StoreHeader extends StatelessWidget {
  final VoidCallback? onPressed;
  const StoreHeader({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppSize.width(width: 2.0),
      children: [
        Column(
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
                  imagePath: AppImages.shopLogo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: AppSize.height(height: 0.6)),
            InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(AppSize.height(height: 0.5)),
              child: Container(
                width: AppSize.height(height: 11.0),
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(height: 0.4),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 0.5),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        color: AppColors.primary,
                        size: AppSize.height(height: 2.0),
                      ),
                      Text(
                        AppStaticKey.message,
                        style: TextStyle(
                          fontSize: AppSize.height(height: 1.5),
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Peak",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSize.height(height: 1.0)),
            Row(
              children: [
                // Star rating
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                ),
                SizedBox(width: 4),
                Text("(230 reviews)", style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: AppSize.height(height: 0.5)),
            Row(
              spacing: AppSize.width(width: 1.0),
              children: [
                ImageIcon(
                  AssetImage(AppIcons.follow),
                  size: AppSize.height(height: 2.0),
                ),
                Text("1k followers", style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: AppSize.height(height: 1.0)),
          ],
        ),
      ],
    );
  }
}
