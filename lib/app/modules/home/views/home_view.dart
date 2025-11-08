import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/dev_data/bannar_dev_data.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/widgets/custom_slider.dart';
import 'package:canuck_mall/app/modules/home/widgets/filter_box.dart';
import 'package:canuck_mall/app/modules/home/widgets/home_drawer.dart';
import 'package:canuck_mall/app/modules/home/widgets/popular_categories.dart';
import 'package:canuck_mall/app/modules/home/widgets/recommended_products.dart';
import 'package:canuck_mall/app/modules/home/widgets/trending_products.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    // Ensure HomeController is registered so `controller` (and Get.find) works.
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title: AppStaticKey.address,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    final result = await Get.toNamed(Routes.searchLocation);
                    if (result != null && result is Map) {
                      final address = (result['address'] ?? '${result['latitude']}, ${result['longitude']}').toString();
                      controller.updateAddress(address);
                    }
                  },
                  child: Obx(() => AppText(
                        title: controller.currentAddress.value,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppSize.height(height: 2.0),
                ),
              ],
            ),
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: AppSize.height(height: 2.0),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.notification);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: AppImage(
              imagePath: AppIcons.notification2,
              width: AppSize.height(height: 3.0),
              height: AppSize.height(height: 3.0),
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: AppColors.error);
              },
            ),
          ),
          SizedBox(width: AppSize.width(width: 2.0)),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.myCart);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: AppImage(
              imagePath: AppIcons.cart,
              width: AppSize.height(height: 3.0),
              height: AppSize.height(height: 3.0),
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: AppColors.error);
              },
            ),
          ),
        ],
      ),
      drawer: HomeDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.searchProductView);
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: SearchBox(redOnly: true),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.height(height: 2.0)),
                  FilterBox(),
                ],
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              CustomSlider(
                onChanged: (value) {},
                length: bannar.length,
                item: bannar,
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Row(
                children: [
                  AppText(
                    title: AppStaticKey.popularCategories,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: AppSize.height(height: 2.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.0,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.category);
                    },
                    child: AppText(
                      title: AppStaticKey.seeAll,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  ImageIcon(
                    AssetImage(AppIcons.arrow),
                    size: AppSize.height(height: 2.0),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.5)),
              PopularCategories(),
              SizedBox(height: AppSize.height(height: 2.0)),
              Row(
                children: [
                  AppText(
                    title: AppStaticKey.recommendedForYou,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: AppSize.height(height: 2.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.0,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.recommendedProductView);
                    },
                    child: AppText(
                      title: AppStaticKey.seeAll,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  ImageIcon(
                    AssetImage(AppIcons.arrow),
                    size: AppSize.height(height: 2.0),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              RecommendedProducts(

              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Row(
                children: [
                  AppText(
                    title: AppStaticKey.trendingProducts,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: AppSize.height(height: 2.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.0,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.trendingProductsView);
                    },
                    child: AppText(
                      title: AppStaticKey.seeAll,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  ImageIcon(
                    AssetImage(AppIcons.arrow),
                    size: AppSize.height(height: 2.0),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              TrendingProducts(),
            ],
          ),
        ),
      ),
    );
  }
}