import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/notification/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(); // Fetch notifications when the controller is initialized
  }

  // Fetch notifications from the API
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

      // Handle 401 Unauthorized error and prompt re-login
      if (e is DioException && e.response?.statusCode == 401) {
        errorMessage.value = 'Session expired. Please log in again.';
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Mark all notifications as read
  void markAllAsRead() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _service.markAllAsRead();
      print('🟢 All notifications marked as read.');

      // Optionally, refresh the notifications after marking them as read
      fetchNotifications();
    } catch (e) {
      print('🔴 Error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
