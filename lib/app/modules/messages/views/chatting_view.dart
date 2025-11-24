import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_message.dart';
import 'package:canuck_mall/app/modules/messages/controllers/chatting_view_controller.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChattingView extends GetView<ChattingViewController> {
  const ChattingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        title: GetBuilder<ChattingViewController>(
          builder: (_) => Text(
            controller.shopName?.value?.isNotEmpty == true ? controller.shopName!.value : 'Chat',
            style: const TextStyle(fontSize: 18.0),
          )),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.messages.isEmpty) {
                return const Center(child: Text('No messages yet'));
              }
              
              return GroupedListView(
              reverse: false,
              order: GroupedListOrder.ASC,
              elements: controller.messages,
              scrollDirection: Axis.vertical,
              controller: controller.scrollController,
              groupBy:
                  (message) => DateTime(
                message.createdAt.year,
                message.createdAt.month,
                message.createdAt.day,
              ),
              groupHeaderBuilder:
                  (Message message) => Padding(
                padding: EdgeInsets.all(AppSize.height(height: 1.0)),
                child: Center(
                  child: AppText(
                    title: DateFormat.yMMMd().format(message.createdAt),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(
                      color: AppColors.gray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              itemBuilder:
                  (context, Message message) => Align(
                alignment:
                    message.isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.height(height: 2.0),
                    horizontal: AppSize.height(height: 3.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(
                      AppSize.height(height: 2.0),
                    ),
                    decoration: BoxDecoration(
                      color:
                          message.isSentByMe
                              ? AppColors.primary
                              : AppColors.lightGray,
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 1.0),
                      ),
                    ),
                    child: AppText(
                      title: message.text,
                      style: TextStyle(
                        color:
                            message.isSentByMe
                                ? AppColors.white
                                : AppColors.black,
                      ),
                      maxLine: 1000,
                    ),
                  ),
                ),
              ),
              );
            }),
          ),
          Container(
            height: AppSize.height(height: 12.0),
            width: double.maxFinite,
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.height(height: 2.0),
                vertical: AppSize.height(height: 1.0),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: AppSize.height(height: 4.0),
                    width: AppSize.height(height: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Refresh action here
                        debugPrint('Refresh button pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.primary,
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: AppSize.height(height: 2.5),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0)),
                  Flexible(
                    child: SizedBox(
                      height: AppSize.height(height: 5.3),
                      child: TextField(
                        controller: controller.messageTextEditingController,
                        decoration: InputDecoration(
                          suffixIcon: Transform.scale(
                            scale: 0.5,
                            child: ImageIcon(AssetImage(AppIcons.emoji)),
                          ),
                          contentPadding: EdgeInsets.only(
                            left: AppSize.height(height: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGray),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                AppSize.height(height: 5.0),
                              ),
                              bottomLeft: Radius.circular(
                                AppSize.height(height: 5.0),
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGray),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                AppSize.height(height: 5.0),
                              ),
                              bottomLeft: Radius.circular(
                                AppSize.height(height: 5.0),
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGray),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                AppSize.height(height: 5.0),
                              ),
                              bottomLeft: Radius.circular(
                                AppSize.height(height: 5.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.sendMessage();

                      controller.messageTextEditingController.clear();
                      controller.update();
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSize.height(height: 1.1)),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            AppSize.height(height: 5.0),
                          ),
                          bottomRight: Radius.circular(
                            AppSize.height(height: 5.0),
                          ),
                        ),
                      ),
                      child: ImageIcon(
                        AssetImage(AppIcons.sendMessage),
                        size: AppSize.height(height: 3.0),
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
