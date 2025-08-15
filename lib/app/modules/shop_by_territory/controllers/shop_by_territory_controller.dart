import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/netwok/store/store_by_territory.dart';
import '../../../utils/log/app_log.dart';
import '../../../model/store/get_teretory_model.dart';

class ShopByTerritoryController extends GetxController {
  final ShopByTerritoryService _service = ShopByTerritoryService();

  // State
  final isLoading = true.obs;
  final territories = <TerritoryData>[].obs;

  // Fetch by territory (searchTerm can be city/keyword)
  Future<void> fetchTerritories(String searchTerm) async {
    final token = LocalStorage.token;
    AppLogger.info('🔑 Using token: $token', tag: 'SHOP_TERRITORY');

    if (token.isEmpty) {
      AppLogger.warning('⚠️ No token found. Returning empty territory list.', tag: 'SHOP_TERRITORY');
      territories.clear();
      isLoading(false);
      return;
    }

    try {
      isLoading(true);
      final result = await _service.getTerritories(token, searchTerm);
      AppLogger.debug('🌐 Territory result: ${result.toJson()}', tag: 'SHOP_TERRITORY');
      if (result.success) {
        territories.value = result.data;
        AppLogger.info('✅ Territories list loaded (${result.data.length} items)', tag: 'SHOP_TERRITORY');
        for (var i = 0; i < result.data.length; i++) {
          final t = result.data[i];
          AppLogger.debug('• [$i] province=${t.province}, productCount=${t.productCount}', tag: 'SHOP_TERRITORY');
        }
        if (result.data.isEmpty) {
          AppLogger.warning('⚠️ Success true but empty territories list', tag: 'SHOP_TERRITORY');
        }
      } else {
        territories.clear();
        AppLogger.warning('⚠️ Territory result returned success=false: ${result.message}', tag: 'SHOP_TERRITORY');
      }
    } catch (e) {
      AppLogger.error('❌ Controller error: $e', tag: 'SHOP_TERRITORY', error: e.toString());
      territories.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTerritories(''); // empty term to fetch all if supported
  }
}
