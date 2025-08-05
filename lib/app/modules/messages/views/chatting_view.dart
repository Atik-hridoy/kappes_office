import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/model/message_and_chat/get_chat_model.dart';
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
        title: const Text('Peak', style: TextStyle(fontSize: 18.0)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: AppText(
                    title: "No messages yet!",
                    style: TextStyle(color: AppColors.gray),
                  ),
                );
              }

              return GroupedListView<Chat, DateTime>(
                reverse: true,
                order: GroupedListOrder.DESC,
                elements: controller.messages,
                groupBy:
                    (message) => DateTime(
                      message.date.year,
                      message.date.month,
                      message.date.day,
                    ),
                groupHeaderBuilder:
                    (Chat message) => Padding(
                      padding: EdgeInsets.all(AppSize.height(height: 1.0)),
                      child: Center(
                        child: AppText(
                          title: DateFormat.yMMMd().format(message.date),
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
                    (context, Chat message) => _buildMessageWidget(message),
              );
            }),
          ),

          // Message Input Area
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  // Helper method to build the message UI
  Widget _buildMessageWidget(Chat message) {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.height(height: 2.0),
          horizontal: AppSize.height(height: 3.0),
        ),
        child: Container(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          decoration: BoxDecoration(
            color: message.isSentByMe ? AppColors.primary : AppColors.lightGray,
            borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
          ),
          child: AppText(
            title: message.message,
            style: TextStyle(
              color: message.isSentByMe ? AppColors.white : AppColors.black,
            ),
            maxLine: 1000,
          ),
        ),
      ),
    );
  }

  // Helper method for the message input area
  Widget _buildMessageInputArea() {
    return Container(
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
            _buildAddButton(),
            SizedBox(width: AppSize.width(width: 2.0)),
            _buildMessageTextField(),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  // Helper method to build the "Add" button (for refresh or any other action)
  Widget _buildAddButton() {
    return SizedBox(
      height: AppSize.height(height: 4.0),
      width: AppSize.height(height: 4.0),
      child: ElevatedButton(
        onPressed: () {
          // Action to refresh messages or trigger other functionality
          debugPrint('Refresh button pressed');
          controller.fetchChats(
            'your-auth-token-here',
          ); // Example of refreshing chat data
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.primary,
        ),
        child: Icon(
          Icons.refresh,
          color: AppColors.white,
          size: AppSize.height(height: 2.5),
        ),
      ),
    );
  }

  // Helper method to build the message text field
  Widget _buildMessageTextField() {
    return Flexible(
      child: SizedBox(
        height: AppSize.height(height: 5.3),
        child: TextField(
          controller: controller.messageTextEditingController,
          decoration: InputDecoration(
            suffixIcon: Transform.scale(
              scale: 0.5,
              child: ImageIcon(AssetImage(AppIcons.emoji)),
            ),
            contentPadding: EdgeInsets.only(left: AppSize.height(height: 2.0)),
            border: _inputBorder(),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorder(),
          ),
        ),
      ),
    );
  }

  // Helper method to define the input border
  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightGray),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppSize.height(height: 5.0)),
        bottomLeft: Radius.circular(AppSize.height(height: 5.0)),
      ),
    );
  }

  // Helper method to build the send button
  Widget _buildSendButton() {
    return InkWell(
      onTap: () {
        controller.sendMessage();
      },
      child: Container(
        padding: EdgeInsets.all(AppSize.height(height: 1.1)),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSize.height(height: 5.0)),
            bottomRight: Radius.circular(AppSize.height(height: 5.0)),
          ),
        ),
        child: ImageIcon(
          AssetImage(AppIcons.sendMessage),
          size: AppSize.height(height: 3.0),
          color: AppColors.white,
        ),
      ),
    );
  }
}
