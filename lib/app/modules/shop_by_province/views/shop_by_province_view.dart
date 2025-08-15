import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
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
                  final loading = controller.isLoading.value;
                  final items = controller.provinces;

                  if (!loading && items.isEmpty) {
                    return Center(
                      child: AppText(
                        title: 'No provinces found',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  return Skeletonizer(
                    enabled: loading,
                    child: ListView.separated(
                      itemCount: loading ? 8 : items.length,
                      itemBuilder: (context, index) {
                        final province = loading
                            ? null
                            : items[index];
                        return InkWell(
                          onTap: () {
                            if (!loading) {
                              Get.toNamed(Routes.searchProductView);
                            }
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
                                Container(
                                  height: AppSize.height(height: 8.0),
                                  width: AppSize.height(height: 8.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGray,
                                    borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
                                  ),
                                  child: Icon(Icons.map, color: AppColors.black),
                                ),
                                SizedBox(width: AppSize.height(height: 1.0)),
                                Expanded(
                                  child: Column(
                                    spacing: AppSize.height(height: 1.0),
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        title: province?.province ?? 'Province Name',
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                              fontSize: AppSize.height(height: 2.0),
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Row(
                                        spacing: AppSize.width(width: 1.5),
                                        children: [
                                          Icon(Icons.store, size: AppSize.height(height: 2.0)),
                                          AppText(
                                            title: '${province?.productCount ?? 0} Products',
                                            style: Theme.of(context).textTheme.bodyMedium,
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
                        return SizedBox(height: AppSize.height(height: 2.0));
                      },
                    ),
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
