import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/category/views/category_view.dart';
import 'package:canuck_mall/app/modules/home/views/home_view.dart';
import 'package:canuck_mall/app/modules/messages/views/messages_view.dart';
import 'package:canuck_mall/app/modules/profile/views/profile_view.dart';
import 'package:canuck_mall/app/modules/saved/views/saved_view.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';

import '../controllers/bottom_nav_controller.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (controller) {
        return Scaffold(
          body: Obx(() => _buildSelectedPage(controller)),
          bottomNavigationBar: _buildBottomNavigationBar(controller),
        );
      },
    );
  }

  Widget _buildSelectedPage(BottomNavController controller) {
    switch (controller.selectedIndex.value) {
      case 0:
        return const HomeView();
      case 1:
        return const MessagesView();
      case 2:
        return const SavedView();
      case 3:
        return const CategoryView();
      case 4:
        return const ProfileView();
      default:
        return const HomeView();
    }
  }

  Widget _buildBottomNavigationBar(BottomNavController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.height(height: 1.0)),
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
          NavigationDestination(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.home, width: 24, height: 24),
            ),
            selectedIcon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.home, width: 24, height: 24),
            ),
            label: AppStaticKey.home,
          ),
          NavigationDestination(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.message, width: 24, height: 24),
            ),
            selectedIcon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.message, width: 24, height: 24),
            ),
            label: AppStaticKey.messages,
          ),
          NavigationDestination(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.favourite, width: 24, height: 24),
            ),
            selectedIcon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.favourite, width: 24, height: 24),
            ),
            label: AppStaticKey.saved,
          ),
          NavigationDestination(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.category, width: 24, height: 24),
            ),
            selectedIcon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.category, width: 24, height: 24),
            ),
            label: AppStaticKey.category,
          ),
          NavigationDestination(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.person, width: 24, height: 24),
            ),
            selectedIcon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.asset(AppIcons.person, width: 24, height: 24),
            ),
            label: AppStaticKey.profile,
          ),
        ],
        elevation: 0,
      ),
    );
  }
}
