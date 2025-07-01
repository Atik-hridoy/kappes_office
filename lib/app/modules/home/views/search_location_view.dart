import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchLocationView extends GetView {
  const SearchLocationView({super.key});
  @override
  Widget build(BuildContext context) {
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
            spacing: AppSize.height(height: 2.0),
            children: [
              SearchBox(title: AppStaticKey.searchLocation),
              SizedBox(
                width: double.maxFinite,
                height: AppSize.height(height: 6.0),
                child: ElevatedButton.icon(
                  onPressed: () {},
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
                  child: Image.asset(AppImages.map, fit: BoxFit.cover),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: "Toronto, Canada",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    AppText(
                      title: "43.651070, -79.347015",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppText(
                title: AppStaticKey.recentLocations,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSize.height(height: 2.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.0,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: "Vancouver, Canada",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    AppText(
                      title: "49.282730, -123.120735",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: "Montreal, Canada",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    AppText(
                      title: "45.501690, -73.567253",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: "Calgary, Canada",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    AppText(
                      title: "51.044270, -114.062019",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppCommonButton(
                onPressed: () {},
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
