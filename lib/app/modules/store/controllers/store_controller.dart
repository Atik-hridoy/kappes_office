import 'package:get/get.dart';
import '../../../data/netwok/store/store_service.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class StoreController extends GetxController {
  final StoreService _storeService = StoreService();

  RxBool isLoading = RxBool(true); // Initially, set loading state to true
  RxString error = RxString(''); // Error message (if any)

  // Store data as a map. Initialize with an empty map.
  RxMap<String, dynamic> store = RxMap<String, dynamic>({});
  RxList<dynamic> products = RxList<dynamic>(
    [],
  ); // Updated to hold a list of products

  // URL fields for dynamic image paths, initialized with empty strings
  RxString shopLogoUrl = RxString('');
  RxString shopCoverUrl = RxString('');
  RxList<String> galleryUrls = RxList<String>([]); // For gallery/banner images

  // Fetch shop details using Shop ID
  Future<void> fetchStoreDetails(String shopId) async {
    try {
      isLoading.value = true; // Set loading state to true before fetching
      update(); // Trigger UI update to show loading indicator
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
      store.value = result['data']; // Set the store data
      error.value = ''; // Clear any previous errors

      // Fetch image URLs dynamically
      shopLogoUrl.value = getImageUrl(result['data']['logo']);
      shopCoverUrl.value = getImageUrl(result['data']['coverPhoto']);

      // Normalize gallery/banner images
      galleryUrls.clear();
      if (result['data']['gallery'] != null &&
          result['data']['gallery'] is List) {
        for (var img in result['data']['gallery']) {
          galleryUrls.add(getImageUrl(img));
        }
      }
      // Always include cover and logo at the start if not empty
      if (shopCoverUrl.value.isNotEmpty) {
        galleryUrls.insert(0, shopCoverUrl.value);
      }
      if (shopLogoUrl.value.isNotEmpty) {
        galleryUrls.insert(0, shopLogoUrl.value);
      }

      // Fetch products for this shop ID
      await fetchProducts(shopId);

      isLoading.value = false; // Set loading to false after data is fetched
      update(); // Trigger UI update after data fetch
      print('[StoreController] Shop details fetched successfully');
    } catch (e) {
      // Handle errors if any occur during data fetching
      error.value = 'Failed to fetch store details';
      print('[StoreController] Error fetching store details: $e');
      isLoading.value = false; // Stop the loading indicator
      update(); // Trigger UI update after an error occurs
    }
  }

  // Fetch products for the store by Shop ID
  Future<void> fetchProducts(String shopId) async {
    try {
      print('[StoreController] Fetching products for Shop ID: $shopId');
      final productData = await _storeService.fetchProductsByShopId(shopId);

      products.clear(); // Clear existing products
      // Normalize product images
      for (var product in productData) {
        if (product['images'] != null && product['images'] is List) {
          product['images'] =
              (product['images'] as List)
                  .map((img) => getImageUrl(img))
                  .toList();
        }
        products.add(product);
      }
      update(); // Trigger UI update after products are fetched
      print('[StoreController] Products fetched successfully: $productData');
    } catch (e) {
      print('[StoreController] Error fetching products: $e');
    }
  }

  // Helper function to construct image URL dynamically
  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http'))
      return path; // If it's already a full URL, return it
    return '${AppUrls.baseUrl}$path'; // Otherwise, construct the full URL
  }

  // Call fetchStoreDetails() with Shop ID when controller is initialized

  @override
  void onInit() {
    super.onInit();
    final shopId =
        Get.arguments
            as String; // Fetch Shop ID passed from the previous screen
    if (shopId.isNotEmpty) {
      fetchStoreDetails(shopId); // Fetch store details for given ID
    }
  }
}
