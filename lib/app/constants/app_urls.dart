abstract class AppUrls {
  static const String baseUrl = 'http://10.10.7.112:7000/api/v1';

  // Auth endpoints
  static const String verifyEmail = '/auth/verify-email';
  static const String login = '/auth/login';
  static const String signUp = '/users';
  static const String forgotPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';

  // Product endpoints
  static const String products = '/products';
  static const String categories = '/categories';
  static const String stores = '/stores';
  static const String recommendedProducts = '/product/recommended';

  // User endpoints
  static const String profile = '/users/profile';
  static const String updateProfile = '/user/update-profile';
  static const String orders = '/user/orders';
}