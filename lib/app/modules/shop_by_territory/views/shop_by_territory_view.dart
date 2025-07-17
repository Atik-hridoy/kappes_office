import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/constants/app_icons.dart';
import '../controllers/shop_by_territory_controller.dart';

class ShopByTerritoryView extends GetView<ShopByTerritoryController> {
  const ShopByTerritoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: 'Territories',  // AppStaticKey.territory or any other title
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                    () {
                  // Check if the data is still loading
                  if (controller.shops.isEmpty) {
                    return Center(child: CircularProgressIndicator());  // Show loading indicator while data is fetched
                  }

                  return ListView.separated(
                    itemCount: controller.shops.length,
                    itemBuilder: (context, index) {
                      var shop = controller.shops[index];
                      return InkWell(
                        onTap: () {
                          // Navigate to the search page or another view
                          Get.toNamed('/searchProductView');
                        },
                        borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
                        child: Container(
                          padding: EdgeInsets.all(AppSize.height(height: 1.0)),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.lightGray),
                            borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
                          ),
                          child: Row(
                            children: [
                              // Display shop logo with fallback
                              AppImage(
                                imagePath: controller.shopLogo(index),  // Use helper for full URL
                                height: AppSize.height(height: 8.0),
                                width: AppSize.height(height: 8.0),
                              ),
                              SizedBox(width: AppSize.height(height: 1.0)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      title: shop['name'] ?? 'Unknown Shop',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontSize: AppSize.height(height: 2.0),
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ImageIcon(
                                          AssetImage(AppIcons.package),
                                          size: AppSize.height(height: 2.0),
                                        ),
                                        SizedBox(width: AppSize.width(width: 1.5)),
                                        Expanded(
                                          child: AppText(
                                            title: "Products: "+(shop['description'] ?? 'No description'),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: AppSize.height(height: 2.3),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: AppSize.height(height: 2.0));  // Spacer between items
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
