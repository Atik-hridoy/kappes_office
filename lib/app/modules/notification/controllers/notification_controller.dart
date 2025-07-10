import 'package:get/get.dart';

import '../../../data/netwok/notification/notification_service.dart';


class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(); // Now fetches all
  }

  void fetchNotifications() async {
    try {
      print('🔵 Fetching all user notifications...');
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _service.fetchAllNotifications();
      print('🟢 Received ${data.length} notifications.');
      notifications.assignAll(data);
    } catch (e) {
      print('🔴 Error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
