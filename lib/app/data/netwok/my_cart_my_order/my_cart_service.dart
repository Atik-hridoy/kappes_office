import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/model/get_cart_model.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CartService extends GetConnect {
  static const String appUrl = AppUrls.baseUrl;
  static const String cartUrl =
      '$appUrl/cart'; // Assuming your cart API endpoint is at '/cart'

  // Initialize Dio instance
  Dio dio = Dio();

  // Function to fetch cart data with token
  Future<GetCartModel> fetchCartData(String token) async {
    try {
      AppLogger.debug("🔵 [CartService] Starting to fetch cart data...");
      
      if (token.isEmpty) {
        AppLogger.error('❌ [CartService] Error: Empty token provided', tag: 'CartService', error: 'Empty token provided');
        throw Exception('Authentication token is empty');
      }

      // Set up Dio headers including the token
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      AppLogger.debug("🔵 [CartService] Making request to: $cartUrl");
      AppLogger.debug("🔵 [CartService] Headers: ${dio.options.headers}");

      // Increase timeout duration for slow server responses
      final response = await dio.get(
        cartUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 20), // Increased send timeout
          receiveTimeout: const Duration(seconds: 20), // Increased receive timeout
        ),
      );

      AppLogger.debug("🟢 [CartService] Response Status: ${response.statusCode}");
      AppLogger.debug("🟢 [CartService] Response Data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data == null) {
          AppLogger.error('❌ [CartService] Error: Response data is null', tag: 'CartService', error: 'Response data is null');
          throw Exception('Received empty response from server');
        }

        try {
          final cartData = GetCartModel.fromJson(response.data);
          AppLogger.debug('✅ [CartService] Successfully parsed cart data');
          return cartData;
        } catch (e) {
          AppLogger.error('❌ [CartService] Error parsing cart data: $e', tag: 'CartService', error: 'Error parsing cart data: $e');
          AppLogger.error('❌ [CartService] Raw response: ${response.data}', tag: 'CartService', error: 'Raw response: ${response.data}');
          throw Exception('Failed to parse cart data: $e');
        }
      } else {
        AppLogger.error('❌ [CartService] Server error: ${response.statusCode} - ${response.statusMessage}', tag: 'CartService', error: 'Server error: ${response.statusCode} - ${response.statusMessage}');
        AppLogger.error('❌ [CartService] Response data: ${response.data}', tag: 'CartService', error: 'Response data: ${response.data}');
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      AppLogger.error('❌ [CartService] Dio Error: ${dioError.type}', tag: 'CartService', error: 'Dio Error: ${dioError.type}');
      AppLogger.error('❌ [CartService] Error message: ${dioError.message}', tag: 'CartService', error: 'Error message: ${dioError.message}');
      AppLogger.error('❌ [CartService] Error response: ${dioError.response?.data}', tag: 'CartService', error: 'Error response: ${dioError.response?.data}');
      AppLogger.error('❌ [CartService] Error request: ${dioError.requestOptions.uri}', tag: 'CartService', error: 'Error request: ${dioError.requestOptions.uri}');
      throw Exception('Network error: ${dioError.message}');
    } catch (e) {
      AppLogger.error('❌ [CartService] Unexpected error: $e', tag: 'CartService', error: 'Unexpected error: $e');
      AppLogger.error('❌ [CartService] Stack trace: ${StackTrace.current}', tag: 'CartService', error: 'Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }
}
