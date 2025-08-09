import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
import 'package:canuck_mall/app/data/netwok/message/get_chat_service.dart';
import 'package:canuck_mall/app/modules/messages/controllers/messages_controller.dart';
import 'package:canuck_mall/app/modules/messages/controllers/chatting_view_controller.dart';
import 'package:get/get.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    // Register services first, then controllers that depend on them
    Get.lazyPut<CreateChatService>(() => CreateChatService());  // Register CreateChatService first
    Get.lazyPut<ChatService>(() => ChatService());  // Register ChatService second
    
    // Now register controllers that depend on the services
    Get.lazyPut<MessagesController>(() => MessagesController());
    Get.lazyPut<ChattingViewController>(() => ChattingViewController(chatService: Get.find<CreateChatService>()));  // Inject CreateChatService into ChattingViewController
  }
}
