import 'package:canuck_mall/app/data/local/storage_service.dart';
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
    print('\n🟡 TrendingProductController: Fetching trending products...');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = LocalStorage.token;
      print('🔐 Token used: $token');

      final result = await _service.getTrendingProducts(token: token);

      print('✅ Total products received: ${result.length}');
      for (var i = 0; i < result.length; i++) {
        final p = result[i];
        final name = p['name'] ?? 'Unnamed';
        final price = p['basePrice'] ?? 'N/A';
        final id = p['_id'] ?? 'No ID';

        print('➡️ Product[$i]: ID=$id | Name="$name" | Price=\$$price');
      }

      products.assignAll(result);
    } catch (e) {
      print('❌ Error while fetching products: $e');
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading.value = false;
      print('📴 Done fetching trending products\n');
    }
  }
}
