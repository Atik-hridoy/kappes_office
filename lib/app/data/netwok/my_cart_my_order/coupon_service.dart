import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/model/coupon_response_model.dart';
import 'package:dio/dio.dart';

class CouponService {
  final Dio _dio;
  CouponService({Dio? dio}) : _dio = dio ?? Dio();

  Future<CouponResponse> validateCoupon({
    required String couponCode,
    required String shopId,
    required double orderAmount,
    String? token,
  }) async {
    try {
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.getCoupon}/$couponCode',
        data: {
          'shopId': shopId,
          'orderAmount': orderAmount,
        },
        options: Options(
          headers: {
            if (token != null) 'resettoken': token,
            'Content-Type': 'application/json',
          },
        ),
      );
      return CouponResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw CouponResponse.fromJson(e.response!.data);
      } else {
        throw Exception('Failed to validate coupon: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
