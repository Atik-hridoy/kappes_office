import 'package:canuck_mall/app/modules/home/controllers/category_view_controller.dart';
import 'package:canuck_mall/app/modules/home/controllers/recommended_product_view_controller.dart';
import 'package:canuck_mall/app/modules/home/controllers/search_location_view_controller.dart';
import 'package:canuck_mall/app/modules/home/controllers/search_product_view_controller.dart';
import 'package:canuck_mall/app/modules/home/controllers/trending_products_view_controller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CategoryViewController>(
      () => CategoryViewController(),
    );

    Get.lazyPut(() => RecommendedProductController()
      );

    Get.lazyPut<SearchProductViewController>(
      () => SearchProductViewController(),
    );
    Get.lazyPut<TrendingProductsController>(
      () => TrendingProductsController(),
    );
    Get.lazyPut<SearchLocationViewController>(
          () => SearchLocationViewController(),
    );
  }
}
