import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/category/views/category_view.dart';
import 'package:canuck_mall/app/modules/home/views/home_view.dart';
import 'package:canuck_mall/app/modules/messages/views/messages_view.dart';
import 'package:canuck_mall/app/modules/profile/views/profile_view.dart';
import 'package:canuck_mall/app/modules/saved/views/saved_view.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>_buildSelectedPage(controller.selectedIndex.value)),
      bottomNavigationBar: Obx(()=>Container(
        padding: EdgeInsets.symmetric(horizontal: AppSize.height(height: 1.0),),
        height: AppSize.height(height: 12),
        width: double.infinity,
        color: AppColors.white,
        child: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          backgroundColor: AppColors.white,
          indicatorColor: AppColors.primary,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            const NavigationDestination(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.home),
                  size: 24.0,
                ),
              ),
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.home),
                  size: 24.0,
                ),
              ),
              label: AppStaticKey.home,
            ),
            const NavigationDestination(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.message),
                  size: 24.0,
                ),
              ),
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.message),
                  size: 24.0,
                ),
              ),
              label: AppStaticKey.messages,
            ),
            const NavigationDestination(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.favourite),
                  size: 24.0,
                ),
              ),
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.favourite),
                  size: 24.0,
                ),
              ),
              label: AppStaticKey.saved,
            ),
            const NavigationDestination(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.category),
                  size: 24.0,
                ),
              ),
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.category),
                  size: 24.0,
                ),
              ),
              label: AppStaticKey.category,
            ),
            const NavigationDestination(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.person),
                  size: 24.0,
                ),
              ),
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                child: ImageIcon(
                  AssetImage(AppIcons.person),
                  size: 24.0,
                ),
              ),
              label: AppStaticKey.profile,
            ),
          ],
          elevation: 0,
        ),
      )),
    );
  }
}

Widget _buildSelectedPage(int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      return HomeView();
    case 1:
      return MessagesView();
    case 2:
       return SavedView();
    case 3:
        return CategoryView();
    case 4:
         return ProfileView();
  // etc.
  }
  return Container(); // Default case
}
