import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/profile/widget/custom_list_tile.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
    class ProfileView extends GetView<ProfileController> {
      const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            // Use Obx to listen to isLoading state for the body
            body: Obx(() {
          if (controller.isLoading.value) {
            // If loading, show a centered CircularProgressIndicator
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary, // Optional: Use your app's primary color
              ),
            );
          } else {
            // If not loading, show the profile content
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      AppImage(
                        imagePath: AppImages.profileScreenBackground,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: AppSize.height(height: 25.0),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: AppSize.height(height: 8.0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSize.height(height: 3.5)),
                              topRight: Radius.circular(AppSize.height(height: 3.5)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: AppSize.width(width: 35.0),
                        child: Container(
                          // ... (your existing circular image container)
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSize.height(height: 100.0),
                            ),
                            border: Border.all(color: Colors.grey, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3), // Corrected withOpacity
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // Added const
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSize.height(height: 100.0),
                            ),
                            child: AppImage(
                              imagePath: AppImages.profileImage, // Consider making this dynamic too
                              fit: BoxFit.cover,
                              width: AppSize.width(width: 30.0),
                              height: AppSize.width(width: 30.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),
                  // Name and Email are already in Obx, they will update when data is fetched
                  Obx(
                        () => AppText(
                      title: controller.name.value.isNotEmpty
                          ? controller.name.value
                          : '-',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: AppSize.height(height: 2.30),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Obx(
                        () => AppText(
                      title: controller.email.value.isNotEmpty
                          ? controller.email.value
                          : '-',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                    child: Column(
                      // The 'spacing' property is not valid for Column.
                      // Use SizedBox between children if you need spacing.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      /// profile settings
                      AppText(
                        title: AppStaticKey.profileSettings,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: AppSize.height(height: 1.80),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.editInformationView);
                        },
                        image: AppIcons.editProfile,
                        title: AppStaticKey.personalInformation,
                      ),

                      /// profile settings
                      SizedBox(height: AppSize.height(height: 1.0)),
                      AppText(
                        title: AppStaticKey.order,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: AppSize.height(height: 1.80),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.myOrders);
                        },
                        image: AppIcons.myOrder,
                        title: AppStaticKey.myOrder,
                      ),

                      /// accounts settings
                      SizedBox(height: AppSize.height(height: 1.0)),
                      AppText(
                        title: AppStaticKey.accountSettings,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: AppSize.height(height: 1.80),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.changePasswordView);
                        },
                        image: AppIcons.changePassword,
                        title: AppStaticKey.changePassword,
                      ),

                      /// support and info
                      SizedBox(height: AppSize.height(height: 1.0)),
                      AppText(
                        title: AppStaticKey.supportAndInfo,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: AppSize.height(height: 1.80),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.supportView);
                        },
                        image: AppIcons.helpAndSupport,
                        title: AppStaticKey.helpAndSupport,
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.dataPrivacyView);
                        },
                        image: AppIcons.privacyAndData,
                        title: AppStaticKey.privacyAndData,
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.termsConditionsView);
                        },
                        image: AppIcons.termsAndConditions,
                        title: AppStaticKey.termsAndConditions,
                      ),

                      /// app settings
                      SizedBox(height: AppSize.height(height: 1.0)),
                      AppText(
                        title: AppStaticKey.appSettings,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: AppSize.height(height: 1.80),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.aboutUsView);
                        },
                        image: AppIcons.aboutThisApp,
                        title: AppStaticKey.aboutUs,
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.toNamed(Routes.languageView);
                        },
                        image: AppIcons.language,
                        title: AppStaticKey.language,
                      ),
                      CustomListTile(
                        onPressed: () {
                          Get.offAllNamed(Routes.login);
                        },
                        image: AppIcons.logOut,
                        title: AppStaticKey.logOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
         }
         )
        );
      }
    );

}
}