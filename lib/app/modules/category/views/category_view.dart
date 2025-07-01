import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../dev_data/categoris_dev_data.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.savedItems,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of columns
            mainAxisSpacing: AppSize.height(height: 1.0),
            crossAxisSpacing: AppSize.height(height: 1.0),
            childAspectRatio: 0.7, // Adjust to fit your design
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.toNamed(Routes.searchProductView);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                spacing: AppSize.height(height: 0.5),
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 100.0),
                      ),
                      border: Border.all(
                        color: AppColors.lightGray,
                        width: 2.0,
                      ),
                    ),
                    child: AppImage(
                      imagePath: categories[index].image,
                      fit: BoxFit.contain,
                      height: AppSize.height(height: 4.5),
                      width: AppSize.height(height: 4.5),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
