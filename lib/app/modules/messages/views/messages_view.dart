import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
// Loading indicator removed as it's not needed
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/messages_controller.dart';

class MessagesView extends GetView<MessagesController> {
  const MessagesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.message,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshMessages,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          children: [
            SearchBox(
              title: AppStaticKey.searchMessage,
              // TODO: Add search functionality
              // onChanged: (value) {
              //   // Implement search functionality
              // },
            ),
            SizedBox(height: AppSize.height(height: 1.0)),
            Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.messages.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text('No messages yet'),
                  ),
                );
              }

              return Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent &&
                        !controller.isLoading.value &&
                        controller.hasMore.value) {
                      controller.fetchMessages();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return _buildMessageItem(context, message);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, dynamic message) {
    final timeFormat = DateFormat('h:mm a');
    
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.chattingView,
          arguments: {
            'chatId': message.chatId,
            'receiverId': message.sender,
          },
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 0.5),
                ),
                child: AppImage(
                  imagePath: AppImages.shopLogo, // Default image, replace with actual user image if available
                  height: AppSize.height(height: 5.0),
                  width: AppSize.height(height: 5.0),
                ),
              ),
              SizedBox(width: AppSize.width(width: 2.0)),
              // Message Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            message.sender,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          timeFormat.format(message.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10.0,
                                color: Colors.grey.shade500,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 0.5)),
                    Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
