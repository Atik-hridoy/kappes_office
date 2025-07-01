import 'package:get/get.dart';

import '../controllers/shop_by_store_controller.dart';

class ShopByStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopByStoreController>(
      () => ShopByStoreController(),
    );
  }
}
