import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import '../controllers/search_location_view_controller.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
              // Search Box
              SearchBox(
                title: AppStaticKey.searchLocation,
                controller: controller.searchController,
              ),
              
              // Use current location button
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
                      borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: AppSize.height(height: 2.0)),

              // Google Map
              Container(
                height: AppSize.height(height: 30.0),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                  child: GoogleMap(
                    initialCameraPosition: controller.initialCameraPosition,
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: controller.selectedMarker.value != null
                        ? {controller.selectedMarker.value!}
                        : {},
                    onTap: (LatLng position) => controller.onMapTap(position), // Handle map tap
                  ),
                ),
              ),
              
              SizedBox(height: AppSize.height(height: 2.0)),

              // Search History
              Container(
                padding: EdgeInsets.all(AppSize.height(height: 1.5)),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: controller.buildSearchHistory(),
              ),
              
              // Confirm Location Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.selectedMarker.value != null
                      ? controller.onConfirmLocation
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.lightGray,
                    padding: EdgeInsets.symmetric(vertical: AppSize.height(height: 1.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                    ),
                  ),
                  child: Text(
                    AppStaticKey.confirmLocation,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontSize: AppSize.height(height: 2.0),
                    ),
                  ),
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
