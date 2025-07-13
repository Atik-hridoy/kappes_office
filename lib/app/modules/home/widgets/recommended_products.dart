import 'package:canuck_mall/app/dev_data/categoris_dev_data.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:flutter/material.dart';

class RecommendedProducts extends StatelessWidget {
  const RecommendedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: AppSize.height(height: 31.0),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          //return ProductCard();
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: AppSize.width(width: 3.0));
        },
      ),
    );
  }
}
