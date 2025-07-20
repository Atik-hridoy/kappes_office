import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/my_cart/saved_service.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class SavedController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchSavedProducts();
  }

  Future<void> deleteProduct(String productId) async {
    print(
      '🟠 [SavedController] DELETE: Attempting to delete product: $productId',
    );
    try {
      final response = await _savedService.deleteProduct(productId);
      print('🟡 [SavedController] DELETE: Backend response: $response');
      await fetchSavedProducts();
      print(
        '🟠 [SavedController] DELETE: Wishlist after delete: ${savedProducts.length} items -> $savedProducts',
      );
      Get.snackbar('Removed', 'Product removed from wishlist');
    } catch (e) {
      print('❌ [SavedController] Error deleting product: $e');
      Get.snackbar('Error', 'Failed to remove product');
    }
  }

  RxList<Map<String, dynamic>> savedProducts = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  final count = 0.obs;
  final SavedService _savedService = SavedService();

  Future<void> saveProduct(Map<String, dynamic> product) async {
    final productId = product['id'] ?? product['_id'] ?? '';
    final productName = product['name'] ?? 'Unknown';
    print(
      '🟢 [SavedController] ADD: Attempting to save product: $productName (ID: $productId)',
    );
    if (productId == '') {
      print('❌ [SavedController] No product ID provided.');
      Get.snackbar('Error', 'No product ID provided');
      return;
    }
    try {
      final response = await _savedService.saveProduct(productId);
      print('🟡 [SavedController] ADD: Backend response: $response');
      await fetchSavedProducts();
      print(
        '🟢 [SavedController] ADD: Wishlist after add: ${savedProducts.length} items -> $savedProducts',
      );
      Get.snackbar('Saved', 'Product added to wishlist');
    } catch (e) {
      print('❌ [SavedController] Error saving product: $e');
      Get.snackbar('Error', 'Failed to save product');
    }
  }

  Future<void> fetchSavedProducts() async {
    print('🟢 [SavedController] FETCH: Fetching wishlist products...');
    isLoading.value = true;
    try {
      final response = await _savedService.fetchWishlistProducts();
      print('🟡 [SavedController] FETCH: Backend response: $response');
      List? items;
      if (response != null && response['data'] != null) {
        if (response['data']['items'] is List) {
          items = response['data']['items'] as List;
        } else if (response['data']['result'] is List &&
            (response['data']['result'] as List).isNotEmpty &&
            response['data']['result'][0]['items'] is List) {
          items = response['data']['result'][0]['items'] as List;
        }
      }
      if (items != null) {
        print('🔵 [SavedController] FETCH: Wishlist items: $items');
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
          '🟣 [SavedController] FETCH: Updated local savedProducts: ${savedProducts.length} items -> $savedProducts',
        );
      } else {
        print(
          '🔴 [SavedController] FETCH: Unexpected response format, could not update local list.',
        );
      }
    } catch (e) {
      print('❌ [SavedController] Error fetching wishlist products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
