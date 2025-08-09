import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/my_cart_service.dart';
import 'package:canuck_mall/app/model/get_cart_model.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class MyCartController extends GetxController {
  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'assets/images/placeholder.png';
    }
    return '${AppUrls.imageUrl}$path';
  }

  void goToCheckout() {
    final items = cartData.value?.data?.items ?? [];
    if (items.isEmpty) {
      Get.snackbar('Error', 'Cart is empty');
      return;
    }

    final products =
        items
            .map(
              (item) => {
                'productId': item.productId?.id,
                'variantId': item.variantId?.id,
                'name': item.productId?.name,
                'variantName': item.variantId?.storage,
                'quantity': item.variantQuantity,
                'price': item.variantPrice,
                'totalPrice': item.totalPrice,
                // add any other fields needed by checkout/order placement
              },
            )
            .toList();

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

  var isLoading = true.obs;
  var cartData = Rxn<GetCartModel>();

  @override
  void onInit() {
    super.onInit();

    _initCart();
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
      isLoading(true);

      final result = await CartService().fetchCartData(token);

      cartData.value = result;
    } catch (e) {
      AppLogger.error("Error fetching cart data: $e");
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
}