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
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          spacing: AppSize.height(height: 2.0),
          children: [
            Row(
              spacing: AppSize.width(width: 2.0),
              children: [
                AppText(
                  title: AppStaticKey.today,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.gray,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Flexible(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
            NotificationCard(
              title: "Backed Shipped!",
              body:
                  """Your Hiking Traveler Backpack is on its way! It will arrive in 3-5 business days.""",
              isRead: true,
            ),
            NotificationCard(
              title: "New Message",
              body:
                  """Your backpack is ready to ship! The seller will dispatch it soon.""",
              isRead: false,
            ),
            NotificationCard(
              title: "Order Confirmed",
              body:
                  """We’ve processed your order. Expect delivery in 3-5 business days.""",
              isRead: true,
            ),

            Row(
              spacing: AppSize.width(width: 2.0),
              children: [
                AppText(
                  title: AppStaticKey.yesterday,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.gray,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Flexible(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
            NotificationCard(
              title: "Out for Delivery!",
              body:
                  """Your Hiking Traveler Backpack is out for delivery today.""",
              isRead: true,
            ),
            NotificationCard(
              title: "Order Confirmed",
              body:
                  """We’ve processed your order. Expect delivery in 3-5 business days.""",
              isRead: true,
            ),
          ],
        ),
      ),
    );
  }
}
