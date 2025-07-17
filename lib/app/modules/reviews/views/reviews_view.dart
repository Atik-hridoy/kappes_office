import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/reviews/widgets/progress_bar.dart';
import 'package:canuck_mall/app/modules/reviews/widgets/review_card.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reviews_controller.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});
  @override
  Widget build(BuildContext context) {
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
        final controller = Get.find<ReviewsController>();
        if (controller.isLoading.value) {
          return Center(child: ProgressBar());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.reviews.isEmpty) {
          return Center(child: Text('No reviews found.'));
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSize.height(height: 2.0)),
            child: Column(
              children: [
                ...controller.reviews.map((review) => ReviewCard(review: review)).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
