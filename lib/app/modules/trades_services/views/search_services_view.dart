import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/trades_services/widgets/trades_card.dart';
import 'package:canuck_mall/app/modules/trades_services/controllers/search_services_controller.dart';
import 'package:canuck_mall/app/modules/trades_services/models/sort_filter_options.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchServicesView extends GetView<SearchServicesController> {
  const SearchServicesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.searchService,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.height(height: 2.0),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search box
                SearchBox(
                  title: AppStaticKey.searchService,
                  onSearch: (value) {
                    // Trigger the search when the user types something
                    controller.searchBusinesses(value);
                  },
                ),
                SizedBox(height: AppSize.height(height: 1.0)),
                Divider(color: AppColors.lightGray),
                SizedBox(height: AppSize.height(height: 0.5)),

                // Filter and sort row
                Row(
                  children: [
                    // Filter icon
                    InkWell(
                      onTap: () => _showFilterDialog(context),
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
                      onTap: () => _showSortDialog(context),
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
              ]),
            ),
          ),

          // Trades cards list
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.height(height: 2.0),
            ),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 5.0)),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 5.0)),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              if (controller.filteredSearchResults.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 5.0)),
                      child: Text("No businesses found."),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final business = controller.filteredSearchResults[index];
                  return Column(
                    children: [
                      TradesCard(
                        onPressed: () {
                          Get.toNamed(Routes.companyDetails, arguments: business.id);
                        },
                        image: business.logo,
                        name: business.name,
                        service: business.service,
                        address: business.location,
                        phone: business.phone,
                      ),
                      // Add separator for all items except the last one
                      index < controller.filteredSearchResults.length - 1
                          ? SizedBox(height: AppSize.height(height: 1.5))
                          : SizedBox.shrink(),
                    ],
                  );
                }, childCount: controller.filteredSearchResults.length),
              );
            }),
          ),

          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: AppSize.height(height: 2.0)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
