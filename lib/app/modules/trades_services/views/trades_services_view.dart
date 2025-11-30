import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/trades_services/widgets/search_box2.dart';
import 'package:canuck_mall/app/modules/trades_services/widgets/trades_card.dart';
import 'package:canuck_mall/app/modules/trades_services/models/sort_filter_options.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/trades_services_controller.dart';

class TradesServicesView extends GetView<TradesServicesController> {
  const TradesServicesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.tradesAndServices,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 1.2),
                    ),
                    child: AppImage(
                      imagePath: AppImages.tradesAndServices,
                      height: AppSize.height(height: 23.0),
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error, color: AppColors.error),
                    ),
                  ),
                  Positioned(
                    top: AppSize.height(height: 3.5),
                    left: 0.0,
                    right: 0.0,
                    child: Column(
                      children: [
                        AppText(
                          title: AppStaticKey.findTrusted,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(
                            fontSize: AppSize.height(height: 2.0),
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                        AppText(
                          title: AppStaticKey.tradesServicesNearYou,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(
                            fontSize: AppSize.height(height: 2.0),
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: AppSize.height(height: 12.5),
                    right: AppSize.width(width: 6.0),
                    left: AppSize.width(width: 6.0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.searchServicesView);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: IgnorePointer(ignoring: true, child: SearchBox2()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),

              // Filter and sort row
              Row(
                children: [
                  // Filter icon
                  InkWell(
                    onTap: () => controller.showFilterDialog.value = true,
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage(AppIcons.filter2),
                          size: AppSize.height(height: 2.0),
                          color: controller.currentFilter.value != FilterOption.all 
                              ? AppColors.primary 
                              : Colors.grey,
                        ),
                        SizedBox(width: AppSize.width(width: 2.0)),
                        AppText(
                          title: AppStaticKey.filter,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: controller.currentFilter.value != FilterOption.all 
                                ? AppColors.primary 
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  // Sort icon
                  InkWell(
                    onTap: () => controller.showSortDialog.value = true,
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage(AppIcons.sort),
                          size: AppSize.height(height: 2.0),
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppSize.width(width: 2.0)),
                        AppText(
                          title: AppStaticKey.sort,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 1.0)),

              /// trades and services
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 5.0)),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 5.0)),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 48, color: AppColors.error),
                          SizedBox(height: AppSize.height(height: 1.0)),
                          AppText(
                            title: controller.errorMessage.value,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSize.height(height: 2.0)),
                          ElevatedButton(
                            onPressed: controller.refreshBusinesses,
                            child: AppText(title: 'Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.filteredBusinesses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 5.0)),
                      child: Column(
                        children: [
                          Icon(Icons.business_center_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: AppSize.height(height: 1.0)),
                          AppText(
                            title: 'No businesses found with current filter',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredBusinesses.length,
                  itemBuilder: (context, index) {
                    final business = controller.filteredBusinesses[index];
                    return TradesCard(
                      onPressed: () {
                        Get.toNamed(Routes.companyDetails, arguments: business);
                      },
                      image: business.logo,
                      name: business.name,
                      service: business.service,
                      address: business.location,
                      phone: business.phone,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: AppSize.height(height: 1.5));
                  },
                );
              }),
              
              // Filter Dialog
              Obx(() {
                if (controller.showFilterDialog.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog<void>(
                      context: context,
                      builder: (context) => _showFilterDialog(context),
                    ).then((_) => controller.showFilterDialog.value = false);
                  });
                }
                return SizedBox.shrink();
              }),
              
              // Sort Dialog  
              Obx(() {
                if (controller.showSortDialog.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog<void>(
                      context: context,
                      builder: (context) => _showSortDialog(context),
                    ).then((_) => controller.showSortDialog.value = false);
                  });
                }
                return SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showFilterDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Businesses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSize.height(height: 1.5)),
            
            ...FilterOption.values.map((filter) => RadioListTile<FilterOption>(
              title: Text(controller.getFilterDisplayName(filter)),
              value: filter,
              groupValue: controller.currentFilter.value,
              onChanged: (value) {
                if (value != null) {
                  controller.updateFilter(value);
                }
              },
            )),
            
            SizedBox(height: AppSize.height(height: 1.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => controller.showFilterDialog.value = false,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showSortDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Businesses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSize.height(height: 1.5)),
            
            ...SortOption.values.map((sort) => RadioListTile<SortOption>(
              title: Text(controller.getSortDisplayName(sort)),
              value: sort,
              groupValue: controller.currentSort.value,
              onChanged: (value) {
                if (value != null) {
                  controller.updateSort(value);
                }
              },
            )),
            
            SizedBox(height: AppSize.height(height: 1.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => controller.showSortDialog.value = false,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

