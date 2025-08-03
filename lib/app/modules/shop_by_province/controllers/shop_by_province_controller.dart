import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/netwok/store/shop_by_province_service.dart';
import '../../../utils/log/app_log.dart';

class ShopByProvinceController extends GetxController {
  var shops = <dynamic>[].obs;
  final ShopByProvinceService _shopByProvinceService = ShopByProvinceService();

  // Fetch shops by province using the token from LocalStorage
  Future<void> fetchShopsByProvince() async {
    final token = LocalStorage.token;
    AppLogger.info('🔑 Using token: $token', tag: 'SHOP_PROVINCE');
    if (token.isNotEmpty) {
      final response = await _shopByProvinceService.getShopsByProvince(token);
      AppLogger.debug('🌐 Raw shops response: $response', tag: 'SHOP_PROVINCE');
      if (response.isNotEmpty &&
          response['success'] == true &&
          response['data'] is Map &&
          response['data']['result'] is List) {
        shops.value = response['data']['result'];
      } else {
        shops.value = [];
      }
      AppLogger.info('🛍️ Loaded ${shops.length} shops', tag: 'SHOP_PROVINCE');
      AppLogger.debug('Shops data: ${shops.toString()}', tag: 'SHOP_PROVINCE');
    } else {
      AppLogger.warning(
        '⚠️ No token found. Returning empty shop list.',
        tag: 'SHOP_PROVINCE',
      );
      shops.value = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchShopsByProvince();
  }
}
