abstract class AppUrls {
  static const String baseUrl = 'http://10.10.7.79:7000/api/v1';
  static const String imageUrl = 'http://10.10.7.79:7000';

  // Auth endpoints

  static const String verifyEmail = '/auth/verify-email';
  static const String login = '/auth/login';
  static const String signUp = '/users';
  static const String forgotPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';

  // Product endpoints

  static const String products = '/products';
  static const String categories = '/category';

  static const String recommendedProducts = '/product/recommended';
  static const String trendingProduct = '/product';

  // User endpoints

  static const String profile = '/users/profile';
  static const String orders = '/user/orders';
  static const String changePassword = '/auth/change-password';
  static const String getPrivacy = '/settings/privacy-policy';
  static const String getTerms = '/settings/termsOfService';

  // home page endpoints

  static const String home = '/home';
  static const String category = '/category';

  // notifications endpoints

  static const String notifications = '/notifications';
  static const String readNotification = '/notifications/';

  // orders

  static const String createOrder = '/order/create';
  static const String getOrders = '/order/my-orders';

  // product details

  static const String getProduct = '/product';
  static const String getProductByShopId = '/shop/products';
  static const String getReviews = '/review/product';
  //static const String getShop = '/shop';
  static const String searchProduct ='/products';
  static const String review = 'review/product/6858dafad21add59c265e18e';

  // shopssssssssssssssssssssssssssss

  static const String getShopsByProvince = '/shop';
  static const String shopByStoreName = '/shop';
  static const String shopByTerritory = '/shop';
  static const String tradeNService = '/business/all';
  static const String offered = '/offered';
  static const String shopLocation = '/shop/location';

  // Coupon endpoint

  static const String getCoupon = '/coupon';
  static const String addToCart = '/cart/create';
  static const String wishlist = '/wishlist';

  // message

  static const String getChatForUser = '/chat/user';
  static const String createChat = '/chat';
  static const String getMessages = 'message/chat';
  static const String createMessage = '/message';
}
class GoogleSignInUrl {
  static const String googleSignInUrl = 'https://localhost:7000/v1/auth/google';
} 
