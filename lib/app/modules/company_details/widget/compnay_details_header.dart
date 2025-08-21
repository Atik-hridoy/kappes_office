import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:flutter/material.dart';

class CompanyDetailsHeader extends StatelessWidget {
  const CompanyDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              imagePath: AppImages.shopLogo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: AppColors.error);
              },
            ),
          ),
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
            // SizedBox(height: AppSize.height(height: 3.0)),
          ],
        ),
      ],
    );
  }
}
