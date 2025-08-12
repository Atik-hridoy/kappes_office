import 'package:canuck_mall/app/modules/notification/widgets/notification_card.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Import skeletonizer package
import 'package:canuck_mall/app/modules/notification/controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.mark_email_read),
            onPressed: controller.markAllAsRead, // Trigger mark all as read
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 10,  // Number of skeleton items to show
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.height(height: 2.0)),
                  child: Container(
                    color: Colors.grey.shade200,
        height: AppSize.height(height: 8.0), // Skeleton height
        child: Row(
          children: [
            CircleAvatar(
              radius: AppSize.height(height: 3.0),
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(width: AppSize.width(width: 2.0)),
            Expanded(
              child: Container(
                color: Colors.grey.shade300,
                height: AppSize.height(height: 6.0),
              ),
            ),
          ],
        ),
      ),
    );
  },
            )
);

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
          return const Center(child: Text("No notifications available."));
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSize.height(height: 1.5)),
          itemBuilder: (context, index) {
            final item = controller.notifications[index];

            return NotificationCard(
              title: item['title'] ?? 'No title',
              body: item['message'] ?? 'No body',
              isRead: item['read'] ?? false,
              createdAt: item['createdAt'] ?? '', // Use correct API field
            );
          },
        );
      }),
    );
  }
}
