import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_location_view_controller.dart';

class SearchLocationView extends GetView<SearchLocationViewController> {
  const SearchLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchLocationViewController());

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: Text(
          AppStaticKey.selectYourLocation,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBox(
                title: AppStaticKey.searchLocation,
                controller: controller.searchController,
              ),
              SizedBox(
                width: double.maxFinite,
                height: AppSize.height(height: 6.0),
                child: ElevatedButton.icon(
                  onPressed: controller.useCurrentLocation,
                  label: Text(
                    AppStaticKey.useCurrentLocation,
                    style: TextStyle(color: AppColors.white),
                  ),
                  icon: Icon(Icons.my_location, color: AppColors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Container(
                height: AppSize.height(height: 30.0),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.0),
                  ),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.0),
                  ),
                  child: controller.buildMap(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(AppSize.height(height: 1.5)),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.5),
                  ),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: controller.buildSearchHistory(),
              ),
              AppCommonButton(
                onPressed: controller.onConfirmLocation,
                title: AppStaticKey.confirmLocation,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.white,
                  fontSize: AppSize.height(height: 2.0),
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
            ],
          ),
        ),
      ),
    );
  }

}
