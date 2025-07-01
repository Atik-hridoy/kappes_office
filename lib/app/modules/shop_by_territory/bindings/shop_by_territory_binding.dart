import 'package:get/get.dart';

import '../controllers/shop_by_territory_controller.dart';

class ShopByTerritoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopByTerritoryController>(
      () => ShopByTerritoryController(),
    );
  }
}
