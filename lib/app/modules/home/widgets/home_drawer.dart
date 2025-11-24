import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.height(height: 2.0),
            vertical: AppSize.height(height: 3.0),
          ),
          child: Column(
            spacing: AppSize.height(height: 0.5),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Container(
                height: AppSize.height(height: 11.0),
                width: AppSize.height(height: 11.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 100.0),
                  ),
                  border: Border.all(color: AppColors.primary, width: 2.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 100.0),
                  ),
                  child: Builder(
                    builder: (context) {
                      // Debug: Check both image sources
                      final myImage = LocalStorage.myImage;
                      final myProfileImage = LocalStorage.myProfileImage;
                      final imageUrl = myProfileImage.isNotEmpty ? myProfileImage : myImage;
                      
                      print('🖼️ Drawer Image Debug:');
                      print('myImage: $myImage');
                      print('myProfileImage: $myProfileImage');
                      print('Final imageUrl: $imageUrl');
                      
                      if (imageUrl.isNotEmpty) {
                        return AppImage(
                          imagePath: imageUrl,
                          width: AppSize.height(height: 11.0),
                          height: AppSize.height(height: 11.0),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('❌ Image load error: $error');
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImages.profileImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        print('📷 Using default profile image');
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AppImages.profileImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              
              // User Name
              AppText(
                title: LocalStorage.myName.isNotEmpty ? LocalStorage.myName : "Guest User",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              // View Profile Button
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.profile);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.height(height: 2.0),
                    vertical: AppSize.height(height: 0.5),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 5.0),
                    ),
                  ),
                  child: AppText(
                    title: AppStaticKey.viewProfile,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Divider(color: Colors.grey.shade200),
              SizedBox(height: AppSize.height(height: 2.0)),

              /// shop by province
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.shopByProvince);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  spacing: AppSize.width(width: 2.0),
                  children: [
                    AppImage(
                      imagePath: AppIcons.shopByProvince,
                      height: AppSize.height(height: 3.0),
                      width: AppSize.height(height: 3.0),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: AppColors.error);
                      },
                    ),
                    AppText(
                      title: AppStaticKey.shopByProvince,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppSize.height(height: 1.80),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade200),

              /// shop by territory
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.shopByTerritory);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  spacing: AppSize.width(width: 2.0),
                  children: [
                    AppImage(
                      imagePath: AppIcons.shopByTerritory,
                      height: AppSize.height(height: 3.0),
                      width: AppSize.height(height: 3.0),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: AppColors.error);
                      },
                      ),
                    AppText(
                      title: AppStaticKey.shopByTerritory,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppSize.height(height: 1.80),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade200),

              /// shop by store
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.shopByStore);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  spacing: AppSize.width(width: 2.0),
                  children: [
                    AppImage(
                      imagePath: AppIcons.shopByStore,
                      height: AppSize.height(height: 3.0),
                      width: AppSize.height(height: 3.0),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: AppColors.error);
                      },
                    ),
                    AppText(
                      title: AppStaticKey.shopByStore,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppSize.height(height: 1.80),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade200),

              /// trades & services
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.tradesServices);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  spacing: AppSize.width(width: 2.0),
                  children: [
                    AppImage(
                      imagePath: AppIcons.deals,
                      height: AppSize.height(height: 3.0),
                      width: AppSize.height(height: 3.0),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: AppColors.error);
                      },
                    ),
                    AppText(
                      title: AppStaticKey.tradesServices,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppSize.height(height: 1.80),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade200),

              /// deals & offers
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.dealsAndOffers);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  spacing: AppSize.width(width: 2.0),
                  children: [
                    AppImage(
                      imagePath: AppIcons.pieIcon,
                      height: AppSize.height(height: 3.0),
                      width: AppSize.height(height: 3.0),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: AppColors.error);
                      },
                    ),
                    AppText(
                      title: AppStaticKey.dealsOffers,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppSize.height(height: 1.80),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade200),
              Spacer(),
              Row(
                spacing: AppSize.width(width: 2.0),
                children: [
                  Icon(Icons.logout, color: AppColors.primary),
                  AppText(
                    title: AppStaticKey.logOuts,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
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
