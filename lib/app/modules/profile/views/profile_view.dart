import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/profile/widget/custom_list_tile.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
          body: Obx(() {
            if (controller.isLoading.value) {
              // Skeleton screen while loading
              return Skeletonizer(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header skeleton
                      Container(
                        width: double.maxFinite,
                        height: AppSize.height(height: 25.0),
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: AppSize.height(height: 1.0)),
                      // Name skeleton
                      Container(
                        width: AppSize.width(width: 40.0),
                        height: AppSize.height(height: 3.0),
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: AppSize.height(height: 1.0)),
                      // Email skeleton
                      Container(
                        width: AppSize.width(width: 60.0),
                        height: AppSize.height(height: 2.0),
                        color: Colors.grey.shade300,
                      ),
                      // List skeletons
                      Padding(
                        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                        child: Column(
                          children: List.generate(
                            6,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: AppSize.height(height: 1.2)),
                              child: Container(
                                height: AppSize.height(height: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
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
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: AppColors.error);
                          },
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSize.height(height: 100.0)),
                              border: Border.all(color: Colors.grey, width: 2.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppSize.height(height: 100.0)),
                              child: Obx(() => AppImage(
                                  imagePath: controller.profileImageUrl.value.isNotEmpty
                                      ? controller.profileImageUrl.value
                                      : AppImages.profileImage,
                                  fit: BoxFit.cover,
                                  width: AppSize.width(width: 30.0),
                                  height: AppSize.width(width: 30.0),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, color: AppColors.error);
                                  },
                                )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 1.0)),
                    Obx(() => AppText(
                      title: controller.fullName.value.isNotEmpty
                          ? controller.fullName.value
                          : '-',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: AppSize.height(height: 2.30),
                        fontWeight: FontWeight.w900,
                      ),
                    )),
                    Obx(() => AppText(
                      title: controller.email.value.isNotEmpty
                          ? controller.email.value
                          : '-',
                      style: Theme.of(context).textTheme.bodySmall,
                    )),
                    Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomListTile(
                            onPressed: () async {
                              final result = await Get.toNamed(Routes.editInformationView);
                              if (result == true) {
                                controller.fetchProfile();
                              }
                            },
                            image: AppIcons.editProfile,
                            title: AppStaticKey.personalInformation,
                          ),
                          CustomListTile(
                            onPressed: () => Get.toNamed(Routes.myOrders),
                            image: AppIcons.myOrder,
                            title: AppStaticKey.myOrder,
                          ),
                          SizedBox(height: AppSize.height(height: 1.0)),
                          AppText(
                            title: AppStaticKey.accountSettings,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: AppSize.height(height: 1.80),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          CustomListTile(
                            onPressed: () => Get.toNamed(Routes.changePasswordView),
                            image: AppIcons.changePassword,
                            title: AppStaticKey.changePassword,
                          ),
                          SizedBox(height: AppSize.height(height: 1.0)),
                          AppText(
                            title: AppStaticKey.supportAndInfo,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: AppSize.height(height: 1.80),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          CustomListTile(
                            onPressed: () => Get.toNamed(Routes.supportView),
                            image: AppIcons.helpAndSupport,
                            title: AppStaticKey.helpAndSupport,
                          ),
                          CustomListTile(
                            onPressed: () => Get.toNamed(Routes.dataPrivacyView),
                            image: AppIcons.privacyAndData,
                            title: AppStaticKey.privacyAndData,
                          ),
                          CustomListTile(
                            onPressed: () => Get.toNamed(Routes.termsConditionsView),
                            image: AppIcons.termsAndConditions,
                            title: AppStaticKey.termsAndConditions,
                          ),
                          SizedBox(height: AppSize.height(height: 1.0)),
                          AppText(
                            title: AppStaticKey.appSettings,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: AppSize.height(height: 1.80),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          CustomListTile(
                            onPressed: () => Get.toNamed(Routes.aboutUsView),
                            image: AppIcons.aboutThisApp,
                            title: AppStaticKey.aboutUs,
                          ),
                          CustomListTile(
                            onPressed: () => Get.toNamed(Routes.languageView),
                            image: AppIcons.language,
                            title: AppStaticKey.language,
                          ),
                          CustomListTile(
                            onPressed: () async {
                              // Show confirmation dialog
                              final shouldLogout = await Get.dialog<bool>(
                                AlertDialog(
                                  title: Text('Logout'),
                                  content: Text('Are you sure you want to log out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: Text('Logout'),
                                    ),
                                  ],
                                ),
                              ) ?? false;

                              if (shouldLogout) {
                                // Clear all authentication data
                                await LocalStorage.clearAll();
                                // Force reload the storage values
                                await LocalStorage.getAllPrefData();
                                // Navigate to login screen
                                Get.offAllNamed(Routes.login);
                              }
                            },
                            image: AppIcons.logOut,
                            title: AppStaticKey.logOut,
                            showArrow: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        );
      },
    );
  }
}