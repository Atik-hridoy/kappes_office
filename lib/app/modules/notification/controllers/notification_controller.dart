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
    fetchNotifications();  // Fetch notifications when the controller is initialized
  }

  // Fetch notifications from the API
  void fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _service.fetchAllNotifications();
      notifications.assignAll(data);
    } catch (e) {
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
      fetchNotifications();  // Refresh after marking as read
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
