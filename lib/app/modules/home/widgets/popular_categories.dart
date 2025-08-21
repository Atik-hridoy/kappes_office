import 'package:canuck_mall/app/dev_data/categoris_dev_data.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class PopularCategories extends StatelessWidget {
  const PopularCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.height(height: 15.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            spacing: AppSize.height(height: 0.5),
            children: [
              Container(
                padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 100.0),
                  ),
                  border: Border.all(color: AppColors.lightGray, width: 2.0),
                ),
                child: AppImage(
                  imagePath: categories[index].image,
                  fit: BoxFit.contain,
                  height: AppSize.height(height: 4.5),
                  width: AppSize.height(height: 4.5),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: AppColors.error);
                  },
                ),
              ),
              SizedBox(
                width: AppSize.width(width: 20.0),
                child: AppText(
                  title: categories[index].name,
                  textAlign: TextAlign.center,
                  maxLine: 2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: AppSize.width(width: 3.0));
        },
      ),
    );
  }
}
