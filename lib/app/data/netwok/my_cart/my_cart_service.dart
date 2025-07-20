import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';

class MyCartService {
  final Dio _dio = Dio();

  // Fetch cart items using token from the API
  Future<List<Map<String, dynamic>>> getCart(String token) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.myCart}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['items'] != null) {
        return List<Map<String, dynamic>>.from(response.data['items']);
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }

  // Add a product to the cart
  Future<bool> addToCart({
    required String token,
    required Map<String, dynamic> cartData,
  }) async {
    try {
      final response = await _dio.post(
        AppUrls.baseUrl + AppUrls.createOrder,
        data: cartData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
        'Add to cart response: \nStatus: ${response.statusCode}\nBody: ${response.data}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Add to cart failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }
}
