import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/search_location_view_controller.dart';

class SearchLocationView extends GetView<SearchLocationViewController> {
  const SearchLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchLocationViewController());

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.selectYourLocation,
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
                  label: AppText(
                    title: AppStaticKey.useCurrentLocation,
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
                  child: _buildMap(context),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: controller.toggleMapType,
                  icon: Icon(Icons.map, color: AppColors.primary),
                  label: Text(
                    "Switch Map Type",
                    style: TextStyle(color: AppColors.primary),
                  ),
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
                child: Obx(() {
                  final marker = controller.selectedMarker.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title:
                            marker != null
                                ? "Selected Location"
                                : "Toronto, Canada",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      AppText(
                        title:
                            marker != null
                                ? "${marker.position.latitude}, ${marker.position.longitude}"
                                : "43.651070, -79.347015",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }),
              ),
              AppCommonButton(
                onPressed: () {
                  final marker = controller.selectedMarker.value;
                  if (marker != null) {
                    Get.back(result: marker.position);
                  } else {
                    Get.snackbar("Error", "Please select a location first");
                  }
                },
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

  Widget _buildMap(BuildContext context) {
    final controller = Get.find<SearchLocationViewController>();

    return Obx(() {
      final camPos =
          controller.dynamicCameraPosition.value ??
          controller.initialCameraPosition;

      return GoogleMap(
        onMapCreated: controller.onMapCreated,
        initialCameraPosition: camPos,
        mapType: controller.mapType.value,
        markers:
            controller.selectedMarker.value != null
                ? {controller.selectedMarker.value!}
                : {},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: true,
        zoomControlsEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
      );
    });
  }

  Widget _buildLocationItem({
    required String title,
    required String coordinates,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSize.height(height: 1.5)),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title: title,
            style: Theme.of(Get.context!).textTheme.titleSmall,
          ),
          AppText(
            title: coordinates,
            style: Theme.of(Get.context!).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
