import 'package:canuck_mall/app/modules/messages/controllers/chatting_view_controller.dart';
import 'package:get/get.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChattingViewController>(
      () => ChattingViewController(),
    );
  }
}
