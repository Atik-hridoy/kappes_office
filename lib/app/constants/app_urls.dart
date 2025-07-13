abstract class AppUrls {
  static const String baseUrl = 'http://10.10.7.112:7000/api/v1';
  static const String imageUrl = 'http://10.10.7.112:7000';

  // Auth endpoints
  static const String verifyEmail = '/auth/verify-email';
  static const String login = '/auth/login';
  static const String signUp = '/users';
  static const String forgotPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';

  // Product endpoints
  static const String products = '/products';
  static const String categories = '/categories';
  //static const String stores = '/stores';
  static const String recommendedProducts = '/product/recommended';
  static const String trendingProduct = '/product';

  // User endpoints
  static const String profile = '/users/profile';
  static const String myOrders = '/order/my-orders';
  static const String orders = '/user/orders';

  // home page endpoints
  static const String home = '/home';


  // notifications endpoints
  static const String notifications = '/notifications';

  // orders
  static const String order = 'order/my-orders';

  // product details
  static const String getProduct = '/product/6858dafad21add59c265e18e';
  static const String getReviews = '/review/product/6858dafad21add59c265e18e';
  static const String getShop = '/shop/685806ee0d8150920d3662a5';
}