import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
import 'package:canuck_mall/app/data/netwok/message/get_message_service.dart';
import 'package:canuck_mall/app/modules/messages/controllers/messages_controller.dart';
import 'package:canuck_mall/app/modules/messages/controllers/chatting_view_controller.dart';
import 'package:get/get.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    // Register services first, then controllers that depend on them
    Get.lazyPut<CreateChatService>(() => CreateChatService());  // Register CreateChatService first
    Get.lazyPut<GetMessageService>(() => GetMessageService());  // Register GetMessageService for fetching messages
    
    // Now register controllers that depend on the services
    Get.lazyPut<MessagesController>(() => MessagesController());
    Get.lazyPut<ChattingViewController>(() => ChattingViewController(
      chatService: Get.find<CreateChatService>(),  // Inject CreateChatService
      messageService: Get.find<GetMessageService>(),  // Inject GetMessageService for fetching messages
    ));
  }
}
