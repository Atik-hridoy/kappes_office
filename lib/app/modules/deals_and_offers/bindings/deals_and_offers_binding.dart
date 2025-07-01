import 'package:get/get.dart';

import '../controllers/deals_and_offers_controller.dart';

class DealsAndOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DealsAndOffersController>(
      () => DealsAndOffersController(),
    );
  }
}
