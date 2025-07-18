import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/my_cart/saved_service.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

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
                .where((item) => item['product'] != null)
                .map<Map<String, dynamic>>((item) {
                  final product = item['product'] as Map<String, dynamic>;
                  String imageUrl = '';
                  if (product['images'] is List &&
                      product['images'].isNotEmpty) {
                    final firstImagePath = product['images'][0];
                    imageUrl = AppUrls.imageUrl + firstImagePath;
                  }
                  return {...product, 'imageUrl': imageUrl};
                })
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

  Future<void> fetchSavedProducts() async {
    print('🟢 [SavedController] Fetching wishlist products...');
    try {
      final response = await _savedService.fetchWishlistProducts();
      print('🟡 [SavedController] Backend response: $response');
      if (response != null &&
          response['data'] != null &&
          response['data']['items'] is List) {
        final items = response['data']['items'] as List;
        print('🔵 [SavedController] Wishlist items: $items');
        savedProducts.value =
            items
                .where((item) => item['product'] != null)
                .map<Map<String, dynamic>>((item) {
                  final product = item['product'] as Map<String, dynamic>;
                  String imageUrl = '';
                  if (product['images'] is List &&
                      product['images'].isNotEmpty) {
                    final firstImagePath = product['images'][0];
                    imageUrl = AppUrls.imageUrl + firstImagePath;
                  }
                  return {...product, 'imageUrl': imageUrl};
                })
                .toList();
        print(
          '🟣 [SavedController] Updated local savedProducts: ${savedProducts.length} items',
        );
      } else {
        print(
          '🔴 [SavedController] Unexpected response format, could not update local list.',
        );
      }
    } catch (e) {
      print('❌ [SavedController] Error fetching wishlist products: $e');
    }
  }
}
