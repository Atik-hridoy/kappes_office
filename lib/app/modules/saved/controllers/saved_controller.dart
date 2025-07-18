import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/my_cart/saved_service.dart';

class SavedController extends GetxController {
  RxList<Map<String, dynamic>> savedProducts = <Map<String, dynamic>>[].obs;

  final count = 0.obs;
  final SavedService _savedService = SavedService();

  Future<void> saveProduct(Map<String, dynamic> product) async {
    final productId = product['id'] ?? product['_id'] ?? '';
    final productName = product['name'] ?? 'Unknown';
    print(
      '🟢 [SavedController] Attempting to save product: $productName (ID: $productId)',
    );
    if (productId == '') {
      print('❌ [SavedController] No product ID provided.');
      Get.snackbar('Error', 'No product ID provided');
      return;
    }
    try {
      final response = await _savedService.saveProduct(productId);
      print('🟡 [SavedController] Backend response: $response');
      // Parse backend response and update local list
      if (response != null &&
          response['data'] != null &&
          response['data']['items'] is List) {
        final items = response['data']['items'] as List;
        print('🔵 [SavedController] Wishlist items: $items');
        savedProducts.value =
            items
                .map<Map<String, dynamic>>(
                  (item) => item['product'] as Map<String, dynamic>,
                )
                .toList();
        print(
          '🟣 [SavedController] Updated local savedProducts: ${savedProducts.length} items',
        );
      } else {
        print(
          '🔴 [SavedController] Unexpected response format, could not update local list.',
        );
      }
      Get.snackbar('Saved', 'Product added to wishlist');
    } catch (e) {
      print('❌ [SavedController] Error saving product: $e');
      Get.snackbar('Error', 'Failed to save product');
    }
  }
}
