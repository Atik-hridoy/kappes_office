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
    print('🔄 Fetching recommended products...');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = LocalStorage.token;
      print('🔐 Token: $token');

      final result = await _service.getRecommendedProducts(token: token);

      print('✅ Products received: ${result.length}');
      for (var p in result) {
        print('📦 Product: ${p['name']} | \$${p['basePrice']}');
      }

      products.assignAll(result);
    } catch (e) {
      print('❌ Error while fetching products: $e');
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading.value = false;
      print('📴 Loading finished');
    }
  }
}
