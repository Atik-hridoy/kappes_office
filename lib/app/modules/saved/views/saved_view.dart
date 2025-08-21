import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/utils/image_utils.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});
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
      body: Obx(() {
        final products = controller.wishlist;
        if (controller.isLoading.value) {
          return Skeletonizer(
            enabled: true,
            child: Padding(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSize.height(height: 2.0),
                  crossAxisSpacing: AppSize.height(height: 2.0),
                  childAspectRatio: 0.65,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  // Show skeleton only if loading, not real product data
                  return Skeletonizer(
                    enabled: true,
                    child: ProductCard(
                      isSaved: true,
                      imageUrl: '',
                      title: '',
                      price: '',
                      productId: '',
                    ),
                  );
                },
              ),
            ),
          );
        }
        if (products.isEmpty) {
          return Center(child: Text('No saved products'));
        }
        return Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSize.height(height: 2.0),
              crossAxisSpacing: AppSize.height(height: 2.0),
              childAspectRatio: 0.65,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final savedItem = products[index];
              final product = savedItem.product;
              final imagePath =
                  product.images.isNotEmpty ? product.images.first : '';
              final imageUrl = imagePath.isNotEmpty
                  ? '${AppUrls.imageUrl}$imagePath'
                  : ImageUtils.productPlaceholder;

              return InkWell(
                onTap: () {
                  Get.toNamed('/product-details', arguments: product.id);
                },
                child: ProductCard(
                  isSaved: true,
                  imageUrl: imageUrl,
                  title: product.name,
                  price: product.basePrice.toString(),
                  productId: product.id,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
