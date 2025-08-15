import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/custom_slider.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import '../../../constants/app_icons.dart';
import '../../../dev_data/bannar_dev_data.dart' show bannar;
import '../../../routes/app_pages.dart';
import '../controllers/shop_by_store_controller.dart';
import '../widgets/store_card.dart';

class ShopByStoreView extends GetView<ShopByStoreController> {
  const ShopByStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.store,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(AppSize.height(height: 2.0)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search box
                SearchBox(),
                SizedBox(height: AppSize.height(height: 2.0)),

                // Banner slider
                CustomSlider(
                  onChanged: (value) {},
                  length: bannar.length,
                  item: bannar,
                ),
                SizedBox(height: AppSize.height(height: 1.0)),
                Divider(color: AppColors.lightGray),
                SizedBox(height: AppSize.height(height: 0.5)),

                // Filter and sort row
                Row(
                  children: [
                    ImageIcon(
                      AssetImage(AppIcons.filter2),
                      size: AppSize.height(height: 2.0),
                    ),
                    SizedBox(width: AppSize.width(width: 2.0)),
                    AppText(
                      title: AppStaticKey.filter,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    ImageIcon(
                      AssetImage(AppIcons.sort),
                      size: AppSize.height(height: 2.0),
                    ),
                    SizedBox(width: AppSize.width(width: 2.0)),
                    AppText(
                      title: AppStaticKey.sort,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.height(height: 0.5)),
                Divider(color: AppColors.lightGray),
                SizedBox(height: AppSize.height(height: 1.0)),
              ]),
            ),
          ),

          // Store items list (reactive)
          Obx(() {
            final loading = controller.isLoading.value;
            final count = loading ? 6 : controller.shops.length;

            if (!loading && count == 0) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                  child: Center(
                    child: AppText(
                      title: 'No shops found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.height(height: 2.0),
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Skeletonizer(
                    enabled: loading,
                    child: Column(
                      children: [
                        if (loading)
                          // Lightweight placeholder card (no network images)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGray),
                              borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: AppSize.height(height: 25.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGray,
                                    borderRadius: BorderRadius.circular(AppSize.height(height: 1.9)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: AppSize.height(height: 13.0),
                                        width: AppSize.height(height: 12.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGray,
                                          borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
                                        ),
                                      ),
                                      SizedBox(width: AppSize.width(width: 2.0)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: AppSize.height(height: 2.2),
                                              width: AppSize.width(width: 30.0),
                                              color: AppColors.lightGray,
                                            ),
                                            SizedBox(height: AppSize.height(height: 1.0)),
                                            Container(
                                              height: AppSize.height(height: 1.8),
                                              width: AppSize.width(width: 50.0),
                                              color: AppColors.lightGray,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                Routes.store,
                              );
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: StoreCard(
                              shopLogo: controller.shopLogo(index),
                              shopCover: controller.shopCover(index),
                              shopName: controller.shopName(index),
                              address: controller.address(index),
                            ),
                          ),
                        index < count - 1
                            ? SizedBox(height: AppSize.height(height: 2.0))
                            : const SizedBox.shrink(),
                      ],
                    ),
                  );
                }, childCount: count),
              ),
            );
          }),

          // Add some bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: AppSize.height(height: 2.0)),
          ),
        ],
      ),
    );
  }
}
