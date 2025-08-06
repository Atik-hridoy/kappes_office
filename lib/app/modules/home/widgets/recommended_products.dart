import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recommended_product_view_controller.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

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
            String imageUrl = 'https://via.placeholder.com/150';
            if (images.isNotEmpty && images[0] != null) {
              // Check if the image path is already a full URL
              if (images[0].toString().startsWith('http')) {
                imageUrl = images[0].toString();
              } else {
                // Remove any leading slashes to prevent double slashes in URL
                String path = images[0].toString().startsWith('/')
                    ? images[0].toString().substring(1)
                    : images[0].toString();
                imageUrl = '${AppUrls.imageUrl}/$path';
              }
            }
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
