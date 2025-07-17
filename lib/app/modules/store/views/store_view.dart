import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/follow_button.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../widgets/product_card.dart';
import '../controllers/store_controller.dart';
import '../widgets/store_header.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: "Store Details",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        final store = controller.store.value;
        if (store.isEmpty) {
          return const Center(child: Text('No store data found.'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Store Banner and Logo
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Banner Image
                  SizedBox(
                    width: double.maxFinite,
                    height: AppSize.height(height: 25.0),
                    child: AppImage(
                      imagePath: controller.shopCoverUrl.value.isNotEmpty
                          ? controller.shopCoverUrl.value
                          : AppImages.banner3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -AppSize.height(height: 7.0),
                    child: Center(
                      child: CircleAvatar(
                        radius: AppSize.height(height: 7.0),
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: AppSize.height(height: 6.5),
                          backgroundColor: Colors.grey[200],
                          child: AppImage(
                            imagePath: controller.shopLogoUrl.value.isNotEmpty
                                ? controller.shopLogoUrl.value
                                : AppImages.shopLogo,
                            fit: BoxFit.cover,
                            width: AppSize.height(height: 13.0),
                            height: AppSize.height(height: 13.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Follow Button
                  Positioned(
                    bottom: AppSize.height(height: 12.0),
                    right: AppSize.width(width: 8.0),
                    child: FollowButton(),
                  ),
                ],
              ),
              // Store Header Section
              StoreHeader(
                onPressed: () {
                  Get.toNamed(Routes.messages);
                },
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              // Store Description
              AppText(
                title: store['description']?.isNotEmpty ?? false
                    ? store['description']
                    : "No description available.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Divider(color: AppColors.lightGray),
              // Banners
              CustomSlider(
                onChanged: (value) {},
                length: 1,
                item: [
                  controller.shopCoverUrl.value.isNotEmpty
                      ? controller.shopCoverUrl.value
                      : AppImages.coverImage
                ],
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              // Store Products Section
              controller.products.isNotEmpty
                  ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSize.height(height: 2.0),
                  crossAxisSpacing: AppSize.height(height: 2.0),
                  childAspectRatio: 0.65,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  print('==================>>> Product: $product');
                  return
                     ProductCard(
                      imageUrl: product['imageUrls'] != null && product['imageUrls'].isNotEmpty
                          ? product['imageUrls'][0]
                          : controller.getImageUrl(product['images'][0]),
                      title: product['name'],
                      price: product['basePrice'].toString(),
                      productId: product['_id'],
                       onTap: () {
                         Get.toNamed(Routes.productDetails, arguments: product['_id']);
                       },
                    );

                },
              )
                  : Center(child: Text('No products available')),
            ],
          ),
        );
      }),
    );
  }
}
