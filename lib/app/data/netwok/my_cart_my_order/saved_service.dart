import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class SavedService {
  Future<Map<String, dynamic>?> deleteProduct(String productId) async {
    final dio = Dio();
    final url = '${AppUrls.baseUrl}${AppUrls.wishlist}/$productId';
    final token = await LocalStorage.getString('token');
    try {
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.data is Map<String, dynamic> ? response.data : null;
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<Map<String, dynamic>?> saveProduct(String productId) async {
    final dio = Dio();
    final url = '${AppUrls.baseUrl}${AppUrls.wishlist}';
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
        print("==========>> saved item in home screen ${response.data}");

        return response.data is Map<String, dynamic> ? response.data : null;
      } else {
        throw Exception('Failed to save product');
      }
    } catch (e) {
      throw Exception('Failed to save product: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchWishlistProducts() async {
    final dio = Dio();
    final url = '${AppUrls.baseUrl}${AppUrls.wishlist}';
    final token = await LocalStorage.getString('token');
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch wishlist products');
      }
    } catch (e) {
      throw Exception('Failed to fetch wishlist products: $e');
    }
  }
}
