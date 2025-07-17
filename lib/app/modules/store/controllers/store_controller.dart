import 'package:get/get.dart';
import '../../../data/netwok/store/store_service.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class StoreController extends GetxController {
  final StoreService _storeService = StoreService();

  RxBool isLoading = RxBool(true);  // Initially, set loading state to true
  RxString error = RxString('');  // Error message (if any)

  // Store data as a map. Initialize with an empty map.
  RxMap<String, dynamic> store = RxMap<String, dynamic>({});
  RxList<dynamic> products = RxList<dynamic>([]); // Updated to hold a list of products

  // URL fields for dynamic image paths, initialized with empty strings
  RxString shopLogoUrl = RxString('');
  RxString shopCoverUrl = RxString('');

  // Fetch shop details using Shop ID
  Future<void> fetchStoreDetails(String shopId) async {
    try {
      isLoading.value = true;  // Set loading state to true before fetching
      update();  // Trigger UI update to show loading indicator
      print('[StoreController] Fetching shop details for shop ID: $shopId');

      // Fetching store details from the service
      final result = await _storeService.fetchShopDetails(shopId);

      // Debugging the fetched shop details
      print('================= SHOP DETAILS =================');
      print('🆔 ID: ${result['data']['_id'] ?? 'N/A'}');
      print('🏪 Name: ${result['data']['name'] ?? 'N/A'}');
      print('📧 Email: ${result['data']['email'] ?? 'N/A'}');
      print('📞 Phone: ${result['data']['phone'] ?? 'N/A'}');
      print('📍 Address: ${result['data']['address'] ?? 'N/A'}');
      print('🖼️ Logo: ${result['data']['logo'] ?? 'N/A'}');
      print('🖼️ Cover Photo: ${result['data']['coverPhoto'] ?? 'N/A'}');
      print('📝 Description: ${result['data']['description'] ?? 'N/A'}');
      print('=================================================');

      // Setting fetched data to the store
      store.value = result['data'];  // Set the store data
      error.value = '';  // Clear any previous errors

      // Fetch image URLs dynamically
      shopLogoUrl.value = getImageUrl(result['data']['logo']);
      shopCoverUrl.value = getImageUrl(result['data']['coverPhoto']);

      // Fetch products for this shop ID
      await fetchProducts(shopId);

      isLoading.value = false;  // Set loading to false after data is fetched
      update();  // Trigger UI update after data fetch
      print('[StoreController] Shop details fetched successfully');
    } catch (e) {
      // Handle errors if any occur during data fetching
      error.value = 'Failed to fetch store details';
      print('[StoreController] Error fetching store details: $e');
      isLoading.value = false;  // Stop the loading indicator
      update();  // Trigger UI update after an error occurs
    }
  }

  // Fetch products for the store by Shop ID
  Future<void> fetchProducts(String shopId) async {
    try {
      print('[StoreController] Fetching products for Shop ID: $shopId');
      final productData = await _storeService.fetchProductsByShopId(shopId);

      // Ensure productData is always a List
      List<dynamic> productsList;
      if (productData is List) {
        productsList = productData;
      } else if (productData is Map) {
        productsList = [productData];
      } else {
        productsList = [];
      }

      products.clear();
      products.addAll(productsList);
      update();
      print('[StoreController] Products fetched successfully.');
      print('================= FETCHED PRODUCT IDs =================');
      if (productsList.isEmpty) {
        print('No products found.');
      } else {
        for (var p in productsList) {
          print('  🆔 Product ID: \x1B[32m${p['id']}\x1B[0m');
        }
      }
      print('======================================================');
    } catch (e) {
      print('[StoreController] Error fetching products: $e');
    }
  }

  // Helper function to construct image URL dynamically
  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;  // If it's already a full URL, return it
    return '${AppUrls.baseUrl}$path';  // Otherwise, construct the full URL
  }

  // Call fetchStoreDetails() with Shop ID when controller is initialized

  @override
  void onInit() {
    super.onInit();
    final shopId = Get.arguments as String;  // Fetch Shop ID passed from the previous screen
    if (shopId.isNotEmpty) {
      fetchStoreDetails(shopId);  // Fetch store details for given ID
    }
  }
}
