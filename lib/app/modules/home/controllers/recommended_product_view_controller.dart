import 'package:canuck_mall/app/data/local/storage_service.dart';
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
    print('\n🟡 RecommendedProductController: Fetching recommended products...');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = LocalStorage.token;
      print('🔐 Token used: $token');

      final result = await _service.getRecommendedProducts(token: token);

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
      print('📴 Done fetching recommended products\n');
    }
  }
}
