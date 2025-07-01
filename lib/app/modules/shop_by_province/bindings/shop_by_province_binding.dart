import 'package:get/get.dart';

import '../controllers/shop_by_province_controller.dart';

class ShopByProvinceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopByProvinceController>(
      () => ShopByProvinceController(),
    );
  }
}
