import 'package:canuck_mall/app/modules/company_details/views/company_about_us_view.dart';
import 'package:canuck_mall/app/modules/my_orders/views/completed_orders_view.dart';
import 'package:canuck_mall/app/modules/my_orders/views/ongoing_orders_view.dart';
import 'package:canuck_mall/app/modules/profile/views/about_us_view.dart';
import 'package:canuck_mall/app/modules/profile/views/change_password_view.dart';
import 'package:canuck_mall/app/modules/profile/views/data_privacy_view.dart';
import 'package:canuck_mall/app/modules/profile/views/edit_information_view.dart';
import 'package:canuck_mall/app/modules/profile/views/language_view.dart';
import 'package:canuck_mall/app/modules/profile/views/support_view.dart';
import 'package:canuck_mall/app/modules/profile/views/terms_conditions_view.dart';
import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/reset_password_view.dart';
import '../modules/auth/views/singup_view.dart';
import '../modules/auth/views/verify_otp_view.dart';
import '../modules/bottom_nav/bindings/bottom_nav_binding.dart';
import '../modules/bottom_nav/views/bottom_nav_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/company_details/bindings/company_details_binding.dart';
import '../modules/company_details/views/company_details_view.dart';
import '../modules/deals_and_offers/bindings/deals_and_offers_binding.dart';
import '../modules/deals_and_offers/views/deals_and_offers_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/recommended_product_view.dart';
import '../modules/home/views/search_location_view.dart';
import '../modules/home/views/search_product_view.dart';
import '../modules/home/views/trending_products_view.dart';
import '../modules/messages/bindings/messages_binding.dart';
import '../modules/messages/views/chatting_view.dart';
import '../modules/messages/views/messages_view.dart';
import '../modules/my_cart/bindings/my_cart_binding.dart';
import '../modules/my_cart/views/checkout_successful_view.dart';
import '../modules/my_cart/views/checkout_view.dart';
import '../modules/my_cart/views/my_cart_view.dart';
import '../modules/my_orders/bindings/my_orders_binding.dart';
import '../modules/my_orders/views/my_orders_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reviews/bindings/reviews_binding.dart';
import '../modules/reviews/views/reviews_view.dart';
import '../modules/saved/bindings/saved_binding.dart';
import '../modules/saved/views/saved_view.dart';
import '../modules/shop_by_province/bindings/shop_by_province_binding.dart';
import '../modules/shop_by_province/views/shop_by_province_view.dart';
import '../modules/shop_by_store/bindings/shop_by_store_binding.dart';
import '../modules/shop_by_store/views/shop_by_store_view.dart';
import '../modules/shop_by_territory/bindings/shop_by_territory_binding.dart';
import '../modules/shop_by_territory/views/shop_by_territory_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/store/bindings/store_binding.dart';
import '../modules/store/views/store_view.dart';
import '../modules/trades_services/bindings/trades_services_binding.dart';
import '../modules/trades_services/views/search_services_view.dart';
import '../modules/trades_services/views/trades_services_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.signUP,
      page: () => const SingUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.verifyOtp,
      page: () => const VerifyOtpView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.resetPassword,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.bottomNav,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.messages,
      page: () => const MessagesView(),
      binding: MessagesBinding(),
    ),
    GetPage(
      name: _Paths.saved,
      page: () => const SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: _Paths.category,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.searchProductView,
      page: () => const SearchProductView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.categoryView,
      page: () => const CategoryView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.recommendedProductView,
      page: () => const RecommendedProductView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.searchProductView,
      page: () => const SearchProductView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.trendingProductsView,
      page: () => const TrendingProductsView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.searchLocation,
      page: () => const SearchLocationView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.reviews,
      page: () => const ReviewsView(),
      binding: ReviewsBinding(),
    ),
    GetPage(
      name: _Paths.store,
      page: () => const StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.myCart,
      page: () => const MyCartView(),
      binding: MyCartBinding(),
    ),
    GetPage(
      name: _Paths.checkoutView,
      page: () => const CheckoutView(),
      binding: MyCartBinding(),
    ),
    GetPage(
      name: _Paths.checkoutSuccessfulView,
      page: () => const CheckoutSuccessfulView(),
      binding: MyCartBinding(),
    ),
    GetPage(
      name: _Paths.myOrders,
      page: () => const MyOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: _Paths.completedOrdersView,
      page: () => const CompletedOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: _Paths.ongoingOrdersView,
      page: () => const OngoingOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: _Paths.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.shopByProvince,
      page: () => const ShopByProvinceView(),
      binding: ShopByProvinceBinding(),
    ),
    GetPage(
      name: _Paths.shopByTerritory,
      page: () => const ShopByTerritoryView(),
      binding: ShopByTerritoryBinding(),
    ),
    GetPage(
      name: _Paths.shopByStore,
      page: () => const ShopByStoreView(),
      binding: ShopByStoreBinding(),
    ),
    GetPage(
      name: _Paths.tradesServices,
      page: () => const TradesServicesView(),
      binding: TradesServicesBinding(),
    ),
    GetPage(
      name: _Paths.dealsAndOffers,
      page: () => const DealsAndOffersView(),
      binding: DealsAndOffersBinding(),
    ),
    GetPage(
      name: _Paths.searchServicesView,
      page: () => const SearchServicesView(),
      binding: TradesServicesBinding(),
    ),
    GetPage(
      name: _Paths.companyDetails,
      page: () => const CompanyDetailsView(),
      binding: CompanyDetailsBinding(),
    ),
    GetPage(
      name: _Paths.companyAboutUsView,
      page: () => const CompanyAboutUsView(),
      binding: CompanyDetailsBinding(),
    ),
    GetPage(
      name: _Paths.chattingView,
      page: () => const ChattingView(),
      binding: MessagesBinding(),
    ),
    GetPage(
      name: _Paths.aboutUsView,
      page: () => const AboutUsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.changePasswordView,
      page: () => const ChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.dataPrivacyView,
      page: () => const DataPrivacyView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.editInformationView,
      page: () => const EditInformationView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.languageView,
      page: () => const LanguageView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.supportView,
      page: () => const SupportView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.termsConditionsView,
      page: () => const TermsConditionsView(),
      binding: ProfileBinding(),
    ),

  ];
}
