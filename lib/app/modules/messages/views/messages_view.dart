import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import '../controllers/messages_controller.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart';

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
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          children: [
            SearchBox(
              title: AppStaticKey.searchMessage,
              onSearch: (query) {
                controller.searchMessages(query);
              },
            ),
            SizedBox(height: AppSize.height(height: 1.0)),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: AppSize.height(height: 5.0),
                                height: AppSize.height(height: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: AppSize.width(width: 2.0)),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: AppSize.height(height: 2.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    SizedBox(height: AppSize.height(height: 1.0)),
                                    Container(
                                      height: AppSize.height(height: 2.0),
                                      width: AppSize.width(width: 30.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                if (controller.messages.isEmpty) {
                  return Center(child: AppText(title: "No messages found"));
                }

                return ListView.separated(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.chattingView, arguments: message);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSize.height(height: 0.5),
                                ),
                                child: AppImage(
                                  // Using a default shop logo since the Shop model doesn't have an image property
                                  imagePath: AppImages.shopLogo,
                                  height: AppSize.height(height: 5.0),
                                  width: AppSize.height(height: 5.0),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, color: AppColors.error);
                                  },
                                ),
                              ),
                              SizedBox(width: AppSize.width(width: 2.0)),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          title: message.participants[1].participantId is Shop
                                              ? (message.participants[1].participantId as Shop).name
                                              : (message.participants[1].participantId as User).fullName,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        AppText(
                                          title: message.lastMessage?.createdAt != null
                                              ? DateFormat.jm().format(DateTime.parse(message.lastMessage!.createdAt))
                                              : "Unknown",
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                            fontSize: 10.0,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppText(
                                      title: message.lastMessage?.text ?? "No message",
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: AppSize.height(height: 1.0));
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}