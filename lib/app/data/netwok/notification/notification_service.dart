import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class NotificationService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchAllNotifications() async {
    final token = LocalStorage.token;

    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.notifications}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;
      print('📦 Full notification response: $data');

      if (data['success'] == true) {
        // ✅ Navigate to the result list inside data
        final result = data['data']['result'];

        if (result is List) {
          return List<Map<String, dynamic>>.from(result);
        } else {
          throw Exception('Expected a list in data.result');
        }
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch notifications');
      }
    } catch (e) {
      throw Exception('Dio Error: $e');
    }
  }


}
