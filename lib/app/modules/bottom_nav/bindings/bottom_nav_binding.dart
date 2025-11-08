import 'package:get/get.dart';

import '../../category/controllers/category_controller.dart';
import '../../home/controllers/category_view_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/controllers/recommended_product_view_controller.dart';
import '../../home/controllers/search_location_view_controller.dart';
import '../../home/controllers/search_product_view_controller.dart';
import '../../home/controllers/trending_products_view_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../profile/controllers/Edit_information_view_controller.dart';
import '../../profile/controllers/about_us_view_controller.dart';
import '../../profile/controllers/change_password_view_controller.dart';
import '../../profile/controllers/data_privacy_view_controller.dart';
import '../../profile/controllers/language_view_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/controllers/terms_condition_view_controller.dart';
import '../../saved/controllers/saved_controller.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    // Bottom Nav Controller
    Get.lazyPut<BottomNavController>(
      () => BottomNavController(),
    );
    
    // Home Tab Controllers
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CategoryViewController>(
      () => CategoryViewController(),
    );
    Get.lazyPut<RecommendedProductController>(
      () => RecommendedProductController(),
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
    
    // Messages Tab Controller
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
    );
    
    // Saved Tab Controller
    Get.lazyPut<SavedController>(
      () => SavedController(),
    );
    
    // Category Tab Controller
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );
    
    // Profile Tab Controllers
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<AboutUsViewController>(
      () => AboutUsViewController(),
    );
    Get.lazyPut<ChangePasswordViewController>(
      () => ChangePasswordViewController(),
    );
    Get.lazyPut<DataPrivacyController>(
      () => DataPrivacyController(),
    );
    Get.lazyPut<EditInformationViewController>(
      () => EditInformationViewController(),
    );
    Get.lazyPut<LanguageViewController>(
      () => LanguageViewController(),
    );
    Get.lazyPut<TermsConditionsController>(
      () => TermsConditionsController(),
    );
  }
}
