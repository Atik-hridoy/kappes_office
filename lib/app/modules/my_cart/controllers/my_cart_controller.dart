import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/my_cart_service.dart';
import 'package:canuck_mall/app/model/get_cart_model.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class MyCartController extends GetxController {
  var isLoading = true.obs;
  var cartData = Rxn<GetCartModel>();
  final _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _fetchCartData(); // Ensure fresh data every time you enter the page
  }

  Future<void> _fetchCartData() async {
    // Clear any existing data in cartData before fetching fresh data
    cartData.value = null;

    // Always reload data when entering the page
    await _initCart();
  }

  Future<void> _initCart() async {
    await LocalStorage.getAllPrefData();
    final token = LocalStorage.token;

    if (token.isEmpty) {
      isLoading(false);
      return;
    }

    await fetchCartData(token);
  }

  Future<void> fetchCartData(String token) async {
    try {
      // Show loading if no data yet
      if (cartData.value == null) {
        isLoading(true);
      }

      // Fetch fresh data in the background
      final result = await CartService().fetchCartData(token);

      // Log the raw response data for debugging
      AppLogger.debug('📦 Fetched cart data: ${result.toString()}');

      // Update the UI with the fresh data
      cartData.value = result;

    } catch (e) {
      AppLogger.error("Error fetching cart data: $e", error: 'Error fetching cart data: $e');

      // Don't hide loading on error if we have no data
      if (cartData.value == null) {
        isLoading(false);
      }
      
      // Handle Dio connection timeout specifically
      if (e.toString().contains("connectionTimeout")) {
        Get.snackbar('Network Error', 'Request timed out. Please try again.');
      } else {
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
      
      rethrow; // Re-throw to allow error handling in the UI if needed
    } finally {
      isLoading(false);
    }
  }

  double get cartTotalPrice {
    if (cartData.value?.data?.items == null) return 0.0;
    return cartData.value!.data!.items!.fold(
      0.0,
      (sum, item) => sum + (item.totalPrice),
    );
  }

  void updateQuantity(int index, int newQuantity) {
    if (cartData.value?.data?.items != null &&
        index < cartData.value!.data!.items!.length) {
      final item = cartData.value!.data!.items![index];
      item.variantQuantity = newQuantity;
      item.totalPrice = item.variantPrice * newQuantity;
      cartData.refresh();
      update();
    }
  }

  void removeCartItem(String productId) {
    cartData.update((cart) {
      cart?.data?.items?.removeWhere((item) => item.productId?.id == productId);
    });
  }

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'assets/images/placeholder.png';  // Default placeholder for missing images
    }

    // Clean up the image URL path (removes extra slashes)
    String cleanPath = path.startsWith('/') ? path.substring(1) : path ?? '';
    cleanPath = cleanPath.replaceAll(RegExp(r'/+'), '/');
    return '${AppUrls.imageUrl}/$cleanPath';
  }

  void goToCheckout() {
    final items = cartData.value?.data?.items ?? [];
    if (items.isEmpty) {
      Get.snackbar('Error', 'Cart is empty');
      return;
    }

    final products = items.map((item) => {
      'productId': item.productId?.id,
      'variantId': item.variantId?.id,
      'name': item.productId?.name,
      'variantName': item.variantId?.storage,
      'quantity': item.variantQuantity,
      'price': item.variantPrice,
      'totalPrice': item.totalPrice,
    }).toList();

    final shopId = items.first.productId?.shopId ?? '';

    Get.toNamed(
      Routes.checkoutView,
      arguments: {
        'products': products,
        'itemCost': cartTotalPrice,
        'shopId': shopId,
      },
    );
  }
}
