import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/home/controllers/search_product_view_controller.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProductView extends GetView<SearchProductViewController> {
  const SearchProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: controller.categoryName ?? "All Products",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchBox(
                title: AppStaticKey.searchProduct,
                onSearch: (value) {
                  // Trigger the search when the user types something
                  controller.searchProducts(name: value);
                },
              ),
              Divider(color: AppColors.lightGray),
              Row(
                children: [
                  // Filter icon
                  ImageIcon(
                    AssetImage(AppIcons.filter2),
                    size: AppSize.height(height: 2.0),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0)),
                  AppText(
                    title: AppStaticKey.filter,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  // Sort icon
                  ImageIcon(
                    AssetImage(AppIcons.sort),
                    size: AppSize.height(height: 2.0),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0)),
                  AppText(
                    title: AppStaticKey.sort,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Divider(color: AppColors.lightGray),

              // Grid View to display search results
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (controller.searchResults.isEmpty) {
                  return const Center(
                    child: Text("No products found."),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    mainAxisSpacing: AppSize.height(height: 2.0),
                    crossAxisSpacing: AppSize.height(height: 2.0),
                    childAspectRatio: 0.65, // Adjust to fit your design
                  ),
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final product = controller.searchResults[index];
                    return InkWell(
                      onTap: () {
                        // Navigate to the product details page when clicked
                        Get.toNamed(Routes.productDetails, arguments: product.id);
                      },
                      child: ProductCard(
                        imageUrl: product.images.isNotEmpty ? product.images[0] : '',
                        title: product.name,
                        price: product.basePrice.toString(),
                        productId: product.id,
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
