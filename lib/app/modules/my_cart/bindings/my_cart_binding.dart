import 'package:canuck_mall/app/modules/my_cart/controllers/checkout_successful_view_controller.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/checkout_view_controller.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/coupon_controller.dart';
import 'package:get/get.dart';

import '../controllers/my_cart_controller.dart';

class MyCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyCartController>(() => MyCartController());
    Get.lazyPut<CheckoutViewController>(() => CheckoutViewController());
    Get.lazyPut<CheckoutSuccessfulViewController>(
      () => CheckoutSuccessfulViewController(),
    );
    Get.lazyPut<CouponController>(() => CouponController());
  }
}
