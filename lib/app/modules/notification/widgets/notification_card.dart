import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final bool isRead;
  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.height(height: 2.0)),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(
              0,
              3,
            ), // changes position of shadow (horizontal, vertical)
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSize.height(height: 1.0),
        children: [
          Visibility(
            visible: isRead,
            replacement: CircleAvatar(
              backgroundColor: Colors.red.withAlpha(20),
              child: Icon(
                Icons.notifications_none,
                color: Colors.red,
                size: AppSize.height(height: 3.0),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.green.withAlpha(20),
              child: Icon(
                Icons.notifications_none,
                color: Colors.green,
                size: AppSize.height(height: 3.0),
              ),
            ),
          ), // Add some spacing
          Expanded(
            // Wrap the Column in Expanded
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.height(height: 0.5),
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween, // Use spaceBetween instead of Spacer
                  children: [
                    AppText(
                      title: title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    AppText(
                      title: "9min ago",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),
                AppText(
                  title: body,
                  maxLine: 5,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
