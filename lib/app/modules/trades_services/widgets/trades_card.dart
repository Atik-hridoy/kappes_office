import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class TradesCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String image;
  final String name;
  final String service;
  final String address;
  final String phone;

  const TradesCard({super.key, required this.image, required this.name, required this.service, required this.address, required this.phone, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(AppSize.height(height: 1.0)),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray),
          borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              imagePath: image,
              height: AppSize.height(height: 12.0),
              width: AppSize.height(height: 12.0),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error, color: AppColors.error),
            ),
            Column(
              spacing: AppSize.height(height: 0.5),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title: name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: AppSize.height(height: 2.0),
                    letterSpacing: 0.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.height(height: 1.0),
                    vertical: AppSize.height(height: 0.5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 0.5),
                    ),
                  ),
                  child: AppText(
                    title: service,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Row(
                  spacing: AppSize.width(width: 1.0),
                  children: [
                    ImageIcon(
                      AssetImage(AppIcons.marker),
                      size: AppSize.height(height: 2.0),
                    ),
                    AppText(
                      title: address,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Row(
                  spacing: AppSize.width(width: 1.0),
                  children: [
                    ImageIcon(
                      AssetImage(AppIcons.phone),
                      size: AppSize.height(height: 2.0),
                    ),
                    AppText(
                      title: phone,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
