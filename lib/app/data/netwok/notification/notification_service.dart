import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import '../../local/storage_keys.dart';

class NotificationService {
  final Dio _dio = Dio();

  // Fetch all notifications for the user
  Future<List<Map<String, dynamic>>> fetchAllNotifications() async {
    try {
      // Fetch token from local storage
      final token = await LocalStorage.getString(LocalStorageKeys.token);

      if (token.isEmpty) {
        throw Exception('Token is missing or expired.');
      }

      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.notifications}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',  // Ensure the Bearer token is passed in the header
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']['result']['result']);
        } else {
          throw Exception('Failed to load notifications');
        }
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mark all notifications as read (PATCH)
  Future<void> markAllAsRead() async {
    try {
      // Fetch token from local storage
      final token = await LocalStorage.getString(LocalStorageKeys.token);

      if (token.isEmpty) {
        throw Exception('Token is missing or expired.');
      }

      final response = await _dio.patch(
        '${AppUrls.baseUrl}${AppUrls.readNotification}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',  // Ensure the Bearer token is passed in the header
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notifications as read');
      }
    } catch (e) {
      rethrow;
    }
  }
}
