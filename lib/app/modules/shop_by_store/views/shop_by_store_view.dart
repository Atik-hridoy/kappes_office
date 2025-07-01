import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/dev_data/bannar_dev_data.dart';
import 'package:canuck_mall/app/dev_data/store_dev_data.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/shop_by_store/widgets/store_card.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/custom_slider.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_by_store_controller.dart';

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
                    // Filter icon
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

                    // Sort icon
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

          // Store items list
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.height(height: 2.0),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap:(){
                        Get.toNamed(Routes.store);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: StoreCard(
                        shopLogo: storeInfo[index].shopLogo,
                        shopCover: storeInfo[index].shopCover,
                        shopName: storeInfo[index].shopName,
                        address: storeInfo[index].address,
                      ),
                    ),
                    // Add separator for all items except the last one
                    index < 4
                        ? SizedBox(height: AppSize.height(height: 2.0))
                        : SizedBox.shrink(),
                  ],
                );
              }, childCount: storeInfo.length),
            ),
          ),

          // Add some bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: AppSize.height(height: 2.0)),
          ),
        ],
      ),
    );
  }
}
