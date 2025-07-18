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

        // Gather all gallery/banner images if available
        List<String> galleryImages = [];
        if (store['gallery'] != null && store['gallery'] is List) {
          galleryImages = List<String>.from(store['gallery']);
        }
        // Add cover and logo to gallery if not present
        if (controller.shopCoverUrl.value.isNotEmpty) {
          galleryImages.insert(0, controller.shopCoverUrl.value);
        }
        if (controller.shopLogoUrl.value.isNotEmpty) {
          galleryImages.insert(0, controller.shopLogoUrl.value);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gallery Carousel
              if (galleryImages.isNotEmpty)
                SizedBox(
                  height: AppSize.height(height: 25.0),
                  child: PageView.builder(
                    itemCount: galleryImages.length,
                    itemBuilder: (context, index) {
                      return AppImage(
                        imagePath: galleryImages[index],
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: AppSize.height(height: 25.0),
                      );
                    },
                  ),
                ),
              // Store Logo (as avatar)
              Center(
                child: CircleAvatar(
                  radius: AppSize.height(height: 7.0),
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: AppSize.height(height: 6.5),
                    backgroundColor: Colors.grey[200],
                    child: AppImage(
                      imagePath:
                          controller.shopLogoUrl.value.isNotEmpty
                              ? controller.shopLogoUrl.value
                              : AppImages.shopLogo,
                      fit: BoxFit.cover,
                      width: AppSize.height(height: 13.0),
                      height: AppSize.height(height: 13.0),
                    ),
                  ),
                ),
              ),
              // Follow Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: AppSize.width(width: 8.0),
                    top: AppSize.height(height: 2.0),
                  ),
                  child: FollowButton(),
                ),
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
                title:
                    store['description']?.isNotEmpty ?? false
                        ? store['description']
                        : "No description available.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Divider(color: AppColors.lightGray),
              // Store Products Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(width: 2.0),
                ),
                child:
                    controller.products.isNotEmpty
                        ? GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppSize.height(height: 2.0),
                                crossAxisSpacing: AppSize.height(height: 2.0),
                                childAspectRatio: 0.65,
                              ),
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            final product = controller.products[index];
                            return InkWell(
                              onTap: () {
                                // Pass the full product object to the details screen
                                Get.toNamed(
                                  Routes.productDetails,
                                  arguments: product,
                                );
                              },
                              child: ProductCard(
                                imageUrl: controller.getImageUrl(
                                  product['images'][0],
                                ),
                                title: product['name'],
                                price: product['basePrice'].toString(),
                                productId: product['id'],
                              ),
                            );
                          },
                        )
                        : Center(child: Text('No products available')),
              ),
            ],
          ),
        );
      }),
    );
  }
}
