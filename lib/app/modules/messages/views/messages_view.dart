import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/messages_controller.dart';

class MessagesView extends GetView<MessagesController> {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch messages for the user (example: userId = '6857d5988a47be1e4bf6adc4')

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
            SearchBox(title: AppStaticKey.searchMessage),
            SizedBox(height: AppSize.height(height: 1.0)),

            // Obx to listen to controller's reactive state
            Expanded(
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                // Error state
                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                // Message list state
                return ListView.separated(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.chattingView);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                          child: Row(
                            spacing: AppSize.width(width: 1.0),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSize.height(height: 0.5),
                                ),
                                child: AppImage(
                                  imagePath: AppImages.shopLogo,
                                  height: AppSize.height(height: 5.0),
                                  width: AppSize.height(height: 5.0),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: AppSize.height(height: 0.5),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          title: message.sender,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                        ),
                                        AppText(
                                          title: "12:32 AM",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall!.copyWith(
                                            fontSize: 10.0,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppText(
                                      title: message.text,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
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
