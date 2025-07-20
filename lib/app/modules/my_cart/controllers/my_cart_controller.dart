import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/netwok/my_cart/my_cart_service.dart';

class MyCartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var totalAmount = 0.0.obs;
  final MyCartService _myCartService = MyCartService();

  // Fetch cart items from the service
  Future<void> fetchCartItems() async {
    final token = await getToken();
    if (token.isNotEmpty) {
      final fetchedCartItems = await _myCartService.getCart(token);
      print('Fetched cart items:');
      print(fetchedCartItems);
      cartItems.value = fetchedCartItems;
      updateTotalAmount();
    } else {
      cartItems.value = [];
    }
  }

  // Fetch token from local storage
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // Update total cart amount
  void updateTotalAmount() {
    totalAmount.value = cartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item['price']?.toString() ?? '0.0') ?? 0.0;
      final qty = item['variantQuantity'] ?? 1;
      return sum + (price * qty);
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }
}
