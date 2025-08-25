import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/netwok/store/shop_by_province_service.dart';
import '../../../utils/log/app_log.dart';
import '../../../model/store/get_province_model.dart';

class ShopByProvinceController extends GetxController {
  final ShopByProvinceService _shopByProvinceService = ShopByProvinceService();

  // State
  final isLoading = true.obs;
  final provinces = <ProvinceData>[].obs;

  // Fetch provinces using the token from LocalStorage
  Future<void> fetchShopsByProvince() async {
    final token = LocalStorage.token;
    AppLogger.info('🔑 Using token: $token', tag: 'SHOP_PROVINCE');
    if (token.isEmpty) {
      AppLogger.warning('⚠️ No token found. Returning empty province list.', tag: 'SHOP_PROVINCE');
      provinces.clear();
      isLoading(false);
      return;
    }

    try {
      isLoading(true);
      final result = await _shopByProvinceService.getShopsByProvince(token);
      AppLogger.debug('🌐 Province result: ${result.toJson()}', tag: 'SHOP_PROVINCE', error: result.toJson());
      if (result.success) {
        provinces.value = result.data;
        // Log the full list and each entry for debugging
        AppLogger.info('✅ Provinces list loaded (${result.data.length} items)', tag: 'SHOP_PROVINCE');
        AppLogger.debug('📃 Provinces list (json): ${result.data.map((e) => e.toJson()).toList()}', tag: 'SHOP_PROVINCE', error: result.data.map((e) => e.toJson()).toList());
        for (var i = 0; i < result.data.length; i++) {
          final p = result.data[i];
          AppLogger.debug('• [$i] province=${p.province}, productCount=${p.productCount}', tag: 'SHOP_PROVINCE', error: p.toJson());
        }
      } else {
        provinces.clear();
        AppLogger.warning('⚠️ Province result returned success=false: ${result.message}', tag: 'SHOP_PROVINCE');
      }
      AppLogger.info('🗺️ Loaded ${provinces.length} provinces', tag: 'SHOP_PROVINCE');
    } catch (e) {
      AppLogger.error('❌ Controller error: $e', tag: 'SHOP_PROVINCE', error: e.toString());
      provinces.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchShopsByProvince();
  }
}
