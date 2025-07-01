import 'package:canuck_mall/app/modules/my_orders/controllers/completed_orders_view_controller.dart';
import 'package:canuck_mall/app/modules/my_orders/controllers/ongoing_orders_view_controller.dart';
import 'package:get/get.dart';

import '../controllers/my_orders_controller.dart';

class MyOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOrdersController>(
      () => MyOrdersController(),
    );
    Get.lazyPut<CompletedOrdersViewController>(
      () => CompletedOrdersViewController(),
    );
    Get.lazyPut<OngoingOrdersViewController>(
      () => OngoingOrdersViewController(),
    );
  }
}
