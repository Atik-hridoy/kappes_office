import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart/my_cart_service.dart';
import 'package:canuck_mall/app/model/get_cart_model.dart';
import 'package:get/get.dart';

class MyCartController extends GetxController {
  var isLoading = true.obs;
  var cartData = Rxn<GetCartModel>();

  @override
  void onInit() {
    super.onInit();
    print("🛒 MyCartController: onInit triggered.");
    _initCart();
  }

  // Load token from local storage and fetch cart
  Future<void> _initCart() async {
    print("🔐 Fetching token from LocalStorage...");
    await LocalStorage.getAllPrefData();

    final token = LocalStorage.token;
    print("🧾 Token loaded: $token");

    if (token.isEmpty) {
      print("❌ MyCartController: No token found. Cannot fetch cart.");
      isLoading(false);
      return;
    }

    await fetchCartData(token);
  }

  Future<void> fetchCartData(String token) async {
    print("🚀 MyCartController: fetchCartData() called");

    try {
      isLoading(true);
      print("⏳ Loading started...");

      final result = await CartService().fetchCartData(token);
      print("✅ Cart data fetched successfully");

      cartData.value = result;
      print("📦 Items in cart: ${result.data?.items?.length ?? 0}");
    } catch (e) {
      print("❗️ Error fetching cart data: $e");
    } finally {
      isLoading(false);
      print("✅ Loading complete.");
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
