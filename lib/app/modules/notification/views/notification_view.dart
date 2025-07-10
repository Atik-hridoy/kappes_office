import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/notification/widgets/notification_card.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.notifications,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text("No notifications available."),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: AppSize.height(height: 1.5)),
          itemBuilder: (context, index) {
            final item = controller.notifications[index];

            return NotificationCard(
              title: item['title'] ?? 'No title',
              body: item['body'] ?? 'No body',
              isRead: item['isRead'] ?? false,
            );
          },
        );
      }),
    );
  }
}
