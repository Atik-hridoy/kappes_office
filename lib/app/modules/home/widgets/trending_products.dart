import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/utils/image_utils.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trending_products_view_controller.dart';

class TrendingProducts extends StatelessWidget {
  const TrendingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrendingProductsController());
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      } else if (controller.products.isEmpty) {
        return const Center(child: Text("No products found."));
      }
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: AppSize.height(height: 31.0)),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            final List images = product['images'] ?? [];
            final imageUrl = images.isNotEmpty
                ? '${AppUrls.imageUrl}/${images[0]}'
                : ImageUtils.productPlaceholder;
            return ProductCard(
              imageUrl: imageUrl,
              title: product['name'] ?? '',
              price: product['basePrice']?.toString() ?? '0.00',
              productId: product['_id'],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: AppSize.width(width: 3.0));
          },
        ),
      );
    });
  }
}
