import 'package:canuck_mall/app/modules/messages/controllers/messages_controller.dart';
import 'package:get/get.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure the controller is lazily loaded or directly loaded
    Get.lazyPut<MessagesController>(() => MessagesController());
  }
}
