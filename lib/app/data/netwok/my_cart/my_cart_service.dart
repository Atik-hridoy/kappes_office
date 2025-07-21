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
      // Print to see when the request starts
      print("Fetching cart data...");

      // Set up Dio headers including the token
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Print the request details for debugging
      print("Request URL: $cartUrl");
      print("Headers: ${dio.options.headers}");

      // Make the GET request
      final response = await dio.get(cartUrl);

      // Print response data for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the response body
        print("Cart data fetched successfully!");
        return GetCartModel.fromJson(response.data);
      } else {
        // If the server returns an error, throw an exception
        print("Failed to load cart. Status Code: ${response.statusCode}");
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      // Print any error that occurs
      print("Error fetching cart: $e");
      throw Exception('Error fetching cart: $e');
    }
  }
}
