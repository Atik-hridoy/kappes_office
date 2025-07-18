import 'package:canuck_mall/app/dev_data/chatting_dev_data.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChattingViewController extends GetxController{
  final messageTextEditingController = TextEditingController();
  RxBool isBoxOpen = false.obs;

  void sentMessage(){
    try{
      final message = Message(text: messageTextEditingController.text, date: DateTime.now(), isSentByMe: true);
      messages.add(message);
      messageTextEditingController.clear();
      update();
    }catch(e,stackTrace){
      AppUtils.appError("error comes from sendMessage method : $e\n$stackTrace");
    }
  }


  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white, // Transparent status bar
        statusBarIconBrightness: Brightness.dark, // Dark icons for light backgrounds
      ));
    });
    super.onInit();
  }

  @override
  void onClose() {
    messageTextEditingController.dispose();
    super.onClose();
  }
}