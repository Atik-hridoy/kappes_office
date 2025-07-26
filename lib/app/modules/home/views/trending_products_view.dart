import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trending_products_view_controller.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';

class TrendingProductsView extends GetView<TrendingProductsController> {
  const TrendingProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.recommendedProduct,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.products.isEmpty) {
          return const Center(child: Text("No products found."));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchBox(title: AppStaticKey.searchProduct),
                    Divider(color: AppColors.lightGray),
                    Row(
                      children: [
                        ImageIcon(
                          AssetImage(AppIcons.filter2),
                          size: AppSize.height(height: 2.0),
                        ),
                        SizedBox(width: AppSize.width(width: 2.0)),
                        AppText(
                          title: AppStaticKey.filter,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        ImageIcon(
                          AssetImage(AppIcons.sort),
                          size: AppSize.height(height: 2.0),
                        ),
                        SizedBox(width: AppSize.width(width: 2.0)),
                        AppText(
                          title: AppStaticKey.sort,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.lightGray),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSize.height(height: 2.0),
                        crossAxisSpacing: AppSize.height(height: 2.0),
                        childAspectRatio: AppSize.width(width: 0.18),
                      ),
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        final List images = product['images'] ?? [];

                        final imageUrl =
                            images.isNotEmpty
                                ? '${AppUrls.imageUrl}${images.first}'
                                : 'https://via.placeholder.com/150';

                        return ProductCard(
                          imageUrl: imageUrl,
                          title: product['name'] ?? '',
                          price: product['basePrice']?.toString() ?? '0.00',
                          productId: product['_id'], // ✅ Pass product ID
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
