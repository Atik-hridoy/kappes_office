import 'package:canuck_mall/app/model/add_to_cart_model.dart.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class CartService {
  final Dio dio = Dio();

  CartService() {
    dio.options.baseUrl = AppUrls.baseUrl;
    dio.options.headers = {'Content-Type': 'application/json'};
  }

  /// Adds a product to the cart
  Future<AddToCartModel> addToCart({
    required String token,
    required String productId,
    required String variantId,
    required int quantity,
  }) async {
    final url = AppUrls.addToCart;

    try {
      print("📦 CartService: Sending POST to $url");
      print(
        "🧾 Payload: productId=$productId, variantId=$variantId, quantity=$quantity",
      );

      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        url,
        data: {
          "items": [
            {
              "productId": productId,
              "variantId": variantId,
              "variantQuantity": quantity,
            },
          ],
        },
      );

      print("✅ Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddToCartModel.fromJson(response.data);
      } else {
        throw Exception('❌ Failed to add to cart: ${response.statusMessage}');
      }
    } catch (e) {
      print("❗ CartService Exception: $e");
      rethrow; // Let the controller catch it
    }
  }
}
