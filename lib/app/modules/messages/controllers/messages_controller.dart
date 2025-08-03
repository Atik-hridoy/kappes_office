// lib/app/modules/messages/controllers/messages_controller.dart
import 'package:canuck_mall/app/data/netwok/message/get_message.dart';
import 'package:canuck_mall/app/dev_data/chatting_dev_data.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  final MessageService messageService;
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  MessagesController(this.messageService);

  @override
  void onInit() {
    super.onInit();
    fetchMessages('6857d5988a47be1e4bf6adc4', 1, 10);
  }

  Future<void> fetchMessages(String userId, int page, int limit) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await messageService.fetchMessages(userId, page, limit);
      messages.assignAll(result as Iterable<Message>);
    } catch (e) {
      errorMessage.value = 'Failed to load messages: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
