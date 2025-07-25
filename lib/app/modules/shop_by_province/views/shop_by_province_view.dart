import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import '../controllers/shop_by_province_controller.dart';

class ShopByProvinceView extends GetView<ShopByProvinceController> {
  const ShopByProvinceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.province,
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
                  // Show a loading spinner while shops data is being fetched
                  if (controller.shops.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.separated(
                    itemCount: controller.shops.length,
                    itemBuilder: (context, index) {
                      var shop = controller.shops[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(Routes.searchProductView);
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
                              AppImage(
                                imagePath: AppUrls.imageUrl + (shop['logo'] ?? ''),
                                height: AppSize.height(height: 8.0),
                                width: AppSize.height(height: 8.0),
                              ),
                              SizedBox(width: AppSize.height(height: 1.0)),
                              Column(
                                spacing: AppSize.height(height: 1.0),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: AppSize.width(width: 60.0),
                                    child: AppText(
                                      title: shop['name'] ?? '',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontSize: AppSize.height(height: 2.0),
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    spacing: AppSize.width(width: 1.5),
                                    children: [
                                      Icon(Icons.store, size: AppSize.height(height: 2.0)),
                                      AppText(
                                        title: "${shop['totalProducts']} Products", // Adjust based on the response structure
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
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
                      return SizedBox(height: AppSize.height(height: 2.0));
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
