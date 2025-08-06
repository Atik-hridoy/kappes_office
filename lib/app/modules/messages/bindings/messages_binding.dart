import 'package:canuck_mall/app/data/netwok/message/get_chat_service.dart';
import 'package:canuck_mall/app/modules/messages/controllers/messages_controller.dart';
import 'package:canuck_mall/app/modules/messages/controllers/chatting_view_controller.dart';
import 'package:get/get.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy load controllers and services
    Get.lazyPut<MessagesController>(() => MessagesController());
    Get.lazyPut<ChattingViewController>(() => ChattingViewController());
    Get.lazyPut<ChatService>(() => ChatService());
  }
}
