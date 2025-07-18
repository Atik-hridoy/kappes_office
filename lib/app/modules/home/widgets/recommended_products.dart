import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recommended_product_view_controller.dart';

class RecommendedProducts extends StatelessWidget {
  const RecommendedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecommendedProductController());
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
            return ProductCard(
              imageUrl: images.isNotEmpty ? images[0] : '',
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
