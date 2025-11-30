import 'package:canuck_mall/app/modules/trades_services/controllers/trades_services_view_controller.dart';
import 'package:canuck_mall/app/modules/trades_services/controllers/search_services_controller.dart';
import 'package:get/get.dart';

import '../controllers/trades_services_controller.dart';

class TradesServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradesServicesController>(
      () => TradesServicesController(),
    );
    Get.lazyPut<TradesServicesViewController>(
      () => TradesServicesViewController(),
    );
    Get.lazyPut<SearchServicesController>(
      () => SearchServicesController(),
    );
  }
}
