import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/model/get_review_model.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

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
                    title: review.customer.fullName,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  AppText(
                    title:
                        "${review.createdAt.day} ${_getMonthName(review.createdAt.month)} ${review.createdAt.year}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              StarRating(
                rating: review.rating,
                filledIcon: Icons.star,
                halfFilledIcon: Icons.star_half,
                emptyIcon: Icons.star_border,
                size: AppSize.height(height: 2.4),
                color: Colors.amber,
                borderColor: Colors.grey,
              ),
            ],
          ),
          AppText(
            title: review.comment,
            maxLine: 500,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (review.images.isNotEmpty) ...[
            SizedBox(height: AppSize.height(height: 2.0)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: AppSize.width(width: 2.0),
                children:
                    review.images
                        .map(
                          (image) => ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSize.height(height: 1.0),
                            ),
                            child: Image.network(
                              image.startsWith('http') ? image : '${AppUrls.baseUrl}$image',
                              height: AppSize.height(height: 8.0),
                              width: AppSize.height(height: 8.0),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: AppSize.height(height: 8.0),
                                width: AppSize.height(height: 8.0),
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
