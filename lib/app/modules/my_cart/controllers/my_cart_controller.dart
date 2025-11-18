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

  @override
  void onInit() {
    super.onInit();
    _fetchCartData(); 
  }

  Future<void> _fetchCartData() async {
    cartData.value = null;

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
      if (cartData.value == null) {
        isLoading(true);
      }
      final result = await CartService().fetchCartData(token);

      AppLogger.debug('📦 Fetched cart data: ${result.toString()}', tag: 'MY_CART', error: result.toString());

      cartData.value = result;

    } catch (e) {
      AppLogger.error("Error fetching cart data: $e", error: 'Error fetching cart data: $e');

      if (cartData.value == null) {
        isLoading(false);
      }
      
      // Don't show error for empty cart scenarios
      if (e.toString().contains("Cart not found") || e.toString().contains("Cart is empty")) {
        AppLogger.debug("📭 Cart is empty - this is normal after order completion", tag: 'MY_CART', error: 'Cart is empty');
      } else if (e.toString().contains("connectionTimeout")) {
        Get.snackbar('Network Error', 'Request timed out. Please try again.');
      } else {
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
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
      return 'assets/images/placeholder.png';  
    }

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    cleanPath = cleanPath.replaceAll(RegExp(r'/+'), '/');
    return '${AppUrls.imageUrl}/$cleanPath';
  }

  void goToCheckout() {
    final items = cartData.value?.data?.items ?? [];
    if (items.isEmpty) {
      Get.snackbar(
        'Error',
        'Cart is empty',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Validate that all items have required data
    for (var item in items) {
      if (item.productId?.id == null || item.variantId?.id == null) {
        Get.snackbar(
          'Error',
          'Some cart items are missing required information',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return;
      }
    }

    final products = items.map((item) => {
      'product': item.productId?.id, 
      'variant': item.variantId?.id, 
      'name': item.productId?.name,
      'variantName': item.variantId?.storage,
      'quantity': item.variantQuantity,
      'price': item.variantPrice,
      'totalPrice': item.totalPrice,
    }).toList();

    final shopId = items.first.productId?.shopId ?? '';
    
    if (shopId.isEmpty) {
      Get.snackbar(
        'Error',
        'Shop information is missing',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    AppLogger.info('Navigating to checkout with ${products.length} products, shopId: $shopId');

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
