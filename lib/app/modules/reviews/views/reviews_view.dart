import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../controllers/reviews_controller.dart';
import '../widgets/review_card.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = Get.arguments as String;

    // Fetch reviews when view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchReviews(productId);
    });

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.reviews,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: AppText(
              title: controller.errorMessage.value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.red),
            ),
          );
        }

        final reviews = controller.reviewsList;

        if (reviews.isEmpty) {
          return Center(
            child: AppText(
              title: "No reviews yet.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        // 👇 Dynamic data calculations
        final total = controller.reviewsList.length;
        final avg = controller.averageRating;
        final ratingCount = controller.ratingCount;
        double getPercent(int star) => controller.getPercent(star);

        // 👇 View layout
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👉 Rebuild same layout as ProgressBar (dynamically)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.5),
                  ),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: AppSize.height(height: 1.0),
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: AppSize.height(height: 3.5),
                            child: AppText(
                              title: avg.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                          StarRating(
                            rating: avg,
                            filledIcon: Icons.star,
                            halfFilledIcon: Icons.star_half,
                            emptyIcon: Icons.star_border,
                            size: AppSize.height(height: 2.0),
                            color: Colors.amber,
                            borderColor: Colors.grey,
                          ),
                          AppText(
                            title: "($total reviews)",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: AppSize.width(width: 4.0)),
                      Column(
                        spacing: AppSize.height(height: 1.0),
                        children: List.generate(5, (i) {
                          final star = 5 - i;
                          final percent = getPercent(star);
                          final count = ratingCount[star];

                          return Row(
                            children: [
                              AppText(
                                title: "$star ★",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: AppSize.width(width: 1.0)),
                              LinearPercentIndicator(
                                animation: true,
                                width: AppSize.height(height: 18.0),
                                lineHeight: AppSize.height(height: 0.8),
                                percent: percent.clamp(0.0, 1.0),
                                backgroundColor: Colors.grey.shade300,
                                progressColor: AppColors.primary,
                                barRadius: Radius.circular(
                                  AppSize.height(height: 20.0),
                                ),
                              ),
                              SizedBox(width: AppSize.width(width: 1.0)),
                              AppText(
                                title: "$count",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSize.height(height: 2.0)),

              // 👉 Dynamic Review Cards
              ...reviews.map(
                (review) => Padding(
                  padding: EdgeInsets.only(bottom: AppSize.height(height: 2.0)),
                  child: ReviewCard(review: review),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
