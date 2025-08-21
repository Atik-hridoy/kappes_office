import 'package:get/get.dart';
import '../../../data/netwok/store/store_service.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

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
  final RxString shopLogoUrl = RxString('');
  final RxString shopCoverUrl = RxString('');
  final RxList<String> galleryUrls = RxList<String>([]); // For gallery/banner images
  
  // Getter for store name
  String get storeName => store['name'] ?? '';
  
  // Getter for store rating
  double get storeRating => (store['rating'] ?? 0).toDouble();
  
  // Getter for review count
  int get reviewCount => store['totalReviews'] ?? 0;
  
  // Getter for store verification status
  bool get isVerified => store['isVerified'] ?? false;

  // Fetch shop details using Shop ID
  Future<void> fetchStoreDetails(String shopId) async {
    try {
      isLoading.value = true; // Set loading state to true before fetching
      update(); // Trigger UI update to show loading indicator
      AppLogger.debug('Fetching shop details for shop ID: $shopId', tag: 'STORE_CONTROLLER');

      // Fetching store details from the service
      final result = await _storeService.fetchShopDetails(shopId);

      // Logging the fetched shop details
      AppLogger.debug(
        'Shop details fetched',
        tag: 'STORE_CONTROLLER',
        context: {
          'id': result['data']['_id'] ?? 'N/A',
          'name': result['data']['name'] ?? 'N/A',
          'email': result['data']['email'] ?? 'N/A',
          'phone': result['data']['phone'] ?? 'N/A',
          'address': result['data']['address'] ?? 'N/A',
          'hasLogo': (result['data']['logo'] != null && result['data']['logo'].toString().isNotEmpty) ? 'Yes' : 'No',
          'hasCoverPhoto': (result['data']['coverPhoto'] != null && result['data']['coverPhoto'].toString().isNotEmpty) ? 'Yes' : 'No',
        },
      );

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
      AppLogger.info('Shop details fetched successfully', tag: 'STORE_CONTROLLER');
    } catch (e) {
      // Handle errors if any occur during data fetching
      error.value = 'Failed to fetch store details';
      AppLogger.error('Error fetching store details: $e', error: 'Error fetching store details: $e', tag: 'STORE_CONTROLLER');
      isLoading.value = false; // Stop the loading indicator
      update(); // Trigger UI update after an error occurs
    }
  }

  // Fetch products for the store by Shop ID
  Future<void> fetchProducts(String shopId) async {
    try {
      AppLogger.debug('Fetching products for Shop ID: $shopId', tag: 'STORE_CONTROLLER');
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
      AppLogger.info('Products fetched successfully', tag: 'STORE_CONTROLLER');
    } catch (e) {
      AppLogger.error('Error fetching products: $e', error: 'Error fetching products: $e', tag: 'STORE_CONTROLLER');
    }
  }

  /// Constructs a complete image URL from a relative path
  /// Returns an empty string if the path is null or empty
  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) {
      return path; // If it's already a full URL, return it
    }
    // Remove any leading slashes to prevent double slashes in URL
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '${AppUrls.imageUrl}/$cleanPath';
  }

  // Call fetchStoreDetails() with Shop ID when controller is initialized

  @override
  void onInit() {
    super.onInit();
    try {
      // Safely get shopId from arguments
      final shopId = Get.arguments?.toString();
      
      if (shopId != null && shopId.isNotEmpty) {
        fetchStoreDetails(shopId);
      } else {
        // Handle case when shopId is not provided
        AppLogger.error(
          'Shop ID is required but not provided',
          error: 'Invalid or missing shopId in route arguments',
        );
        Get.back(); // Go back to previous screen if no shopId
      }
    } catch (e, stackTrace) {
      // Handle any other errors
      AppLogger.error(
        'Error initializing StoreController',
        error: e.toString(),
      );
      Get.back(); // Go back to previous screen on error
    }
  }
}
