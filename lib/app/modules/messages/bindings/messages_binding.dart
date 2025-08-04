import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/modules/messages/controllers/chatting_view_controller.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/modules/messages/controllers/messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    // Get the current user ID from storage
    final currentUserId = LocalStorage.userId; // Assuming this is where you store the user ID
    
    if (currentUserId.isEmpty) {
      throw Exception('User ID not found. Please log in again.');
    }
    
    Get.lazyPut<MessagesController>(
      () => MessagesController(userId: currentUserId),
    );
    Get.lazyPut<ChattingViewController>(() => ChattingViewController());
  }
}
