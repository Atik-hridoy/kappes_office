abstract class AppUrls {
  static const String baseUrl = 'http://10.0.60.110:7000/api/v1';

  // Auth endpoints
  static const String verifyEmail = '/auth/verify-email'; // already correct for /api/v1/auth/verify-email
  static const String login = '/auth/login';
  static const String signUp = '/users';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Product endpoints
  static const String products = '/products';
  static const String categories = '/categories';
  static const String stores = '/stores';
  static const String recommendedProducts = '/product/recommended';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String orders = '/user/orders';
}