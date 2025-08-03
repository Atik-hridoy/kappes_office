// lib/app/modules/messages/bindings/messages_binding.dart
import 'package:canuck_mall/app/data/netwok/message/get_message.dart';
import 'package:get/get.dart';
import '../controllers/messages_controller.dart';

class MessagesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageService>(() => MessageService());
    Get.lazyPut<MessagesController>(
      () => MessagesController(Get.find<MessageService>()),
    );
  }
}
