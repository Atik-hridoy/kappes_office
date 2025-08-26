import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import '../../../data/netwok/home/recommended_product_service.dart';

class RecommendedProductController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final products = <Map<String, dynamic>>[].obs;

  final _service = RecommendedProductService();

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedProducts();
  }

  Future<void> fetchRecommendedProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = LocalStorage.token;

      final result = await _service.getRecommendedProducts(token: token);

      AppLogger.debug('✅ Total products received: ${result.length}', error: result.length);
      for (var i = 0; i < result.length; i++) {
        final p = result[i];
        final name = p['name'] ?? 'Unnamed';
        final price = p['basePrice'] ?? 'N/A';
        final id = p['_id'] ?? 'No ID';

        AppLogger.debug(
          '➡️ Product[$i]: ID=$id | Name="$name" | Price=\$$price',
          tag: 'RECOMMENDED_PRODUCTS',
          error: '➡️ Product[$i]: ID=$id | Name="$name" | Price=\$$price',
        );
      }

      products.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading.value = false;
        AppLogger.debug('📴 Done fetching recommended products', tag: 'RECOMMENDED_PRODUCTS', error: '📴 Done fetching recommended products');
      }
  }
}
