import 'package:canuck_mall/app/data/netwok/my_cart_my_order/coupon_service.dart';
import 'package:canuck_mall/app/model/coupon_response_model.dart';
import 'package:flutter/material.dart';

class CouponController extends ChangeNotifier {
  final CouponService _couponService;
  CouponController({CouponService? couponService})
    : _couponService = couponService ?? CouponService();

  CouponResponse? couponResponse;
  String? errorMessage;
  bool isLoading = false;

  Future<void> applyCoupon(String code, {String? token}) async {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty) {
      errorMessage = 'Please enter a coupon code.';
      notifyListeners();
      return;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      couponResponse = await _couponService.validateCoupon(
        couponCode: trimmedCode,
        token: token,
      );
    } on CouponResponse catch (e) {
      errorMessage = e.message;
      couponResponse = null;
    } catch (e) {
      errorMessage = e.toString();
      couponResponse = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
