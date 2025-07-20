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
        '${AppUrls.baseUrl}${AppUrls.createOrder}',
        data: orderData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          print('Unexpected response format');
          return null;
        }
      } else {
        print(
          'Order creation failed: ${response.statusCode} - ${response.statusMessage}',
        );
        if (response.data != null) {
          print('Response data: ${response.data}');
        }
        return null;
      }
    } on DioError catch (dioError) {
      print('Dio error creating order: ${dioError.message}');
      if (dioError.response != null) {
        print('Response data: ${dioError.response?.data}');
      }
      return null;
    } catch (e) {
      print('Unexpected error creating order: $e');
      return null;
    }
  }
}
