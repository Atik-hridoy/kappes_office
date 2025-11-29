abstract class AppUrls {
  //static const String baseUrl = 'http://10.10.7.103:7001/api/v1';
  //static const String imageUrl = 'http://10.10.7.103:7001';

   static const String baseUrl = 'https://asif7001.binarybards.online/api/v1';
   static const String imageUrl = 'https://asif7001.binarybards.online';



  static const String verifyEmail = '/auth/verify-email';
  static const String login = '/auth/login';
  static const String signUp = '/users';
  static const String forgetPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';
  static const String resendOtp = '/auth/resend-otp'; 



  static const String products = '/products';
  static const String categories = '/category';

  static const String recommendedProducts = '/product/recommended';
  static const String trendingProduct = '/product';



  static const String profile = '/users/profile';
  static const String orders = '/user/orders';
  static const String changePassword = '/auth/change-password';
  static const String getPrivacy = '/settings/privacy-policy';
  static const String getTerms = '/settings/termsOfService';
  static const String getContact = '/settings/contact';



  static const String home = '/home';
  static const String category = '/category';



  static const String notifications = '/notifications';
  static const String readNotification = '/notifications/';



   static const String createOrder = '/order/create';
  static const String getOrders = '/order/my-orders';



  static const String getProduct = '/product';
  static const String getProductByShopId = '/shop/products';
  static const String getReviews = '/review/product';
  static const String searchProduct ='/product';
  static const String review = 'review/product/6858dafad21add59c265e18e';



  static const String getShopsByProvince = '/shop/provinces';
 
  static const String shopByTerritory = '/shop/territory';
  static const String tradeNService = '/business/all';
  static const String offered = '/offered';
  static const String shopLocation = '/shop/location';




  static const String getAllShops = '/shop';
  static const String getAllProductsByShopId = '/shop/products'; // +shopid 


  static const String getCoupon = '/coupon';
  static const String addToCart = '/cart/create';
  static const String wishlist = '/wishlist';
  static const String shipping = '/settings/shipping-details';



  static const String getChatForUser = '/chat/user';
  static const String createChat = '/chat';
  static const String getMessages = 'message/chat';
  static const String createMessage = '/message';



  static const String getAllVerifiedBusinesses = '/business/all';
  static const String getBusinessById = '/business/';

  static const String getBusinessMessage = '/business/message/';

  static const String socketUrl = 'https://10.10.7.103:6002';
  
}
class GoogleSignInUrl {
  static const String googleSignInUrl = 'https://localhost:7000/v1/auth/google';
} 
