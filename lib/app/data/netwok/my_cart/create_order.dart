import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';

class CreateOrderService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final response = await _dio.post(
        AppUrls.baseUrl + AppUrls.createOrder,
        data: orderData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        print('Order creation failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }
}