import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';

import '../../../data/netwok/home/trending_products_view_service.dart';

class TrendingProductsController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final products = <Map<String, dynamic>>[].obs;

  final _service = TrendingProductsService();

  @override
  void onInit() {
    super.onInit();
    fetchTrendingProducts();
  }

  Future<void> fetchTrendingProducts() async {
    AppLogger.debug(
      '\n🟡 TrendingProductController: Fetching trending products...',
    );
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = LocalStorage.token;
      AppLogger.debug('🔐 Token used: $token');

      final result = await _service.getTrendingProducts(token: token);

      AppLogger.debug('✅ Total products received: ${result.length}');
      for (var i = 0; i < result.length; i++) {
        final p = result[i];
        final name = p['name'] ?? 'Unnamed';
        final price = p['basePrice'] ?? 'N/A';
        final id = p['_id'] ?? 'No ID';

        AppLogger.debug(
          '➡️ Product[$i]: ID=$id | Name="$name" | Price=\$$price',
        );
      }

      products.assignAll(result);
    } catch (e) {
      AppLogger.error('❌ Error while fetching products: $e');
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading.value = false;
      AppLogger.debug('📴 Done fetching trending products\n');
    }
  }
}
