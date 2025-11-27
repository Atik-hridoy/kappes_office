import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with Get.put if not already in bindings
    final CategoryController controller = Get.put(CategoryController());
    // Fetch categories on view load
    controller.fetchCategories();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.category,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.error.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        } else if (controller.categories.isEmpty) {
          return const Center(child: Text('No categories available.'));
        }
        return Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Number of columns
              mainAxisSpacing: AppSize.height(height: 1.0),
              crossAxisSpacing: AppSize.height(height: 1.0),
              childAspectRatio: 0.7, // Adjust to fit your design
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return InkWell(
                onTap: () {
                  // Navigate to search product view with category filter
                  Get.toNamed(
                    Routes.searchProductView,
                    arguments: {
                      'categoryId': category['_id'],
                      'categoryName': category['name'],
                    },
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Expanded(
                child: Column(
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
                        imagePath: category['thumbnail'] ?? '',
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
                        title: category['name'] ?? '',
                        textAlign: TextAlign.center,
                        maxLine: 2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
