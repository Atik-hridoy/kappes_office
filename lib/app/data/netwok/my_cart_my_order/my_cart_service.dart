import 'package:canuck_mall/app/model/get_cart_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CartService extends GetConnect {
  static const String appUrl = 'http://10.10.7.112:7000/api/v1';
  static const String cartUrl =
      '$appUrl/cart'; // Assuming your cart API endpoint is at '/cart'

  // Initialize Dio instance
  Dio dio = Dio();

  // Function to fetch cart data with token
  Future<GetCartModel> fetchCartData(String token) async {
    try {
      print("🔵 [CartService] Starting to fetch cart data...");
      
      if (token.isEmpty) {
        print('❌ [CartService] Error: Empty token provided');
        throw Exception('Authentication token is empty');
      }

      // Set up Dio headers including the token
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      print("🔵 [CartService] Making request to: $cartUrl");
      print("🔵 [CartService] Headers: ${dio.options.headers}");

      // Make the GET request with timeout
      final response = await dio.get(
        cartUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      print("🟢 [CartService] Response Status: ${response.statusCode}");
      print("🟢 [CartService] Response Data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data == null) {
          print('❌ [CartService] Error: Response data is null');
          throw Exception('Received empty response from server');
        }
        
        try {
          final cartData = GetCartModel.fromJson(response.data);
          print('✅ [CartService] Successfully parsed cart data');
          return cartData;
        } catch (e) {
          print('❌ [CartService] Error parsing cart data: $e');
          print('❌ [CartService] Raw response: ${response.data}');
          throw Exception('Failed to parse cart data: $e');
        }
      } else {
        print('❌ [CartService] Server error: ${response.statusCode} - ${response.statusMessage}');
        print('❌ [CartService] Response data: ${response.data}');
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      print('❌ [CartService] Dio Error: ${dioError.type}');
      print('❌ [CartService] Error message: ${dioError.message}');
      print('❌ [CartService] Error response: ${dioError.response?.data}');
      print('❌ [CartService] Error request: ${dioError.requestOptions.uri}');
      throw Exception('Network error: ${dioError.message}');
    } catch (e) {
      print('❌ [CartService] Unexpected error: $e');
      print('❌ [CartService] Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }
}
