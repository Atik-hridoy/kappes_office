import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppSize.height(height: 1.5),
        ),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          AppSize.height(height: 2.0),
        ),
        child: Row(
          spacing: AppSize.width(width: 2.0),
          children: [
            Column(
              spacing: AppSize.height(height: 1.0),
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: AppSize.height(height: 3.5),
                  child: AppText(
                    title: "4.5",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.white),
                  ),
                ),
                StarRating(
                  rating: 5.0,
                  filledIcon: Icons.star,
                  halfFilledIcon: Icons.star,
                  emptyIcon: Icons.star,
                  size: AppSize.height(height: 2.0),
                  color: Colors.amber, // Color for filled and half-filled icons
                  borderColor: Colors.grey, // Color for empty icons
                ),
                AppText(
                  title: "(320 reviews)",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.0),
                ),
              ],
            ),
            Column(
              spacing: AppSize.height(height: 1.0),
              children: [
                Row(
                  children: [
                    AppText(
                      title: AppStaticKey.fiveStars,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      width: AppSize.height(height: 18.0),
                      lineHeight: AppSize.height(height: 0.8),
                      percent: 0.7,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: AppColors.primary,
                      barRadius: Radius.circular(AppSize.height(height: 20.0),),
                    ),
                    AppText(
                      title: "200",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppText(
                      title: AppStaticKey.fourStars,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      animationDuration: 1000,
                      width: AppSize.height(height: 18.0),
                      lineHeight: AppSize.height(height: 0.8),
                      percent: 0.6,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: AppColors.primary,
                      barRadius: Radius.circular(AppSize.height(height: 20.0),),
                    ),
                    AppText(
                      title: "150",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppText(
                      title: AppStaticKey.threeStars,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      width: AppSize.height(height: 18.0),
                      lineHeight: AppSize.height(height: 0.8),
                      percent: 0.5,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: AppColors.primary,
                      barRadius: Radius.circular(AppSize.height(height: 20.0),),
                    ),
                    AppText(
                      title: "90",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppText(
                      title: AppStaticKey.twoStars,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      width: AppSize.height(height: 18.0),
                      lineHeight: AppSize.height(height: 0.8),
                      percent: 0.4,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: AppColors.primary,
                      barRadius: Radius.circular(AppSize.height(height: 20.0),),
                    ),
                    AppText(
                      title: "30",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppText(
                      title: AppStaticKey.oneStars,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      width: AppSize.height(height: 18.0),
                      lineHeight: AppSize.height(height: 0.8),
                      percent: 0.3,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: AppColors.primary,
                      barRadius: Radius.circular(AppSize.height(height: 20.0),),
                    ),
                    AppText(
                      title: "20",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500, letterSpacing: 0.0),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
