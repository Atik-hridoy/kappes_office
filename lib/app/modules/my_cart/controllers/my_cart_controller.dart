import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/my_cart_service.dart';
import 'package:canuck_mall/app/model/get_cart_model.dart';
import 'package:get/get.dart';

class MyCartController extends GetxController {
  var isLoading = true.obs;
  var cartData = Rxn<GetCartModel>();

  @override
  void onInit() {
    super.onInit();

    _initCart();
  }

  // Load token from local storage and fetch cart
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

    } finally {
      isLoading(false);

    }
  }

  double calculateTotalPrice() {
    double total = 0;
    if (cartData.value?.data?.items != null) {
      for (var item in cartData.value!.data!.items!) {
        total += item.totalPrice;
      }
    }
    print("💰 Total price calculated: \$${total.toStringAsFixed(2)}");
    return total;
  }

  void removeCartItem(String productId) {
    print("🗑 Removing item with ID: $productId");

    // Example of local removal
    cartData.update((cart) {
      cart?.data?.items?.removeWhere((item) => item.productId?.id == productId);
    });

    print(
      "🧹 Item removed locally. (Consider calling delete API and re-fetching)",
    );
  }
}
