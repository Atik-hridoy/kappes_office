import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendedProductView extends GetView {
  const RecommendedProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.recommendedProduct,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSize.height(height: 1.0),
            children: [
              SearchBox(title: AppStaticKey.searchProduct),
              Divider(color: AppColors.lightGray),
              Row(
                children: [
                  /// filter icon
                  ImageIcon(
                    AssetImage(AppIcons.filter2),
                    size: AppSize.height(height: 2.0),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0),),
                  AppText(
                    title: AppStaticKey.filter,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                  ),

                  Spacer(),

                  /// sort icon
                  ImageIcon(
                    AssetImage(AppIcons.sort),
                    size: AppSize.height(height: 2.0),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0),),
                  AppText(
                    title: AppStaticKey.sort,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Divider(color: AppColors.lightGray),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  mainAxisSpacing: AppSize.height(height: 2.0),
                  crossAxisSpacing: AppSize.height(height: 2.0),
                  childAspectRatio: AppSize.width(width: 0.18), // Adjust to fit your design
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Get.toNamed(AppRoutes.productDetailsScreen);
                    },
                    child: ProductCard(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
