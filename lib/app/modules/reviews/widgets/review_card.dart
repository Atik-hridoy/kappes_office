import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.height(height: 2.0)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
      ),
      child: Column(
        spacing: AppSize.height(height: 2.0),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                spacing: AppSize.height(height: 0.5),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title: "Randy Orton",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  AppText(
                    title: "2 March 2025",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Spacer(),
              StarRating(
                rating: 4.0,
                filledIcon: Icons.star,
                halfFilledIcon: Icons.star,
                emptyIcon: Icons.star,
                size: AppSize.height(height: 2.4),
                color: Colors.amber, // Color for filled and half-filled icons
                borderColor: Colors.grey, // Color for empty icons
              ),
            ],
          ),
          AppText(
            title:
                """Absolutely love this sweater! So soft perfect for layering or wearing on its own. It feels luxurious!""",
            maxLine: 500,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            spacing: AppSize.width(width: 2.0),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 1.0),
                ),
                child: AppImage(
                  imagePath: AppImages.shirt2,
                  height: AppSize.height(height: 8.0),
                  width: AppSize.height(height: 8.0),
                  fit: BoxFit.cover,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 1.0),
                ),
                child: AppImage(
                  imagePath: AppImages.shirt1,
                  height: AppSize.height(height: 8.0),
                  width: AppSize.height(height: 8.0),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
