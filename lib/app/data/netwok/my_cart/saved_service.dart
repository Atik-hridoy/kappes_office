import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class SavedService {
  Future<Map<String, dynamic>?> saveProduct(String productId) async {
    final dio = Dio();
    final url = AppUrls.baseUrl + AppUrls.wishlist;
    final token = await LocalStorage.getString('token');
    try {
      final response = await dio.post(
        url,
        data: {'productId': productId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data is Map<String, dynamic> ? response.data : null;
      } else {
        throw Exception('Failed to save product');
      }
    } catch (e) {
      throw Exception('Failed to save product: $e');
    }
  }
}
