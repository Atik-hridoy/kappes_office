import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/netwok/product_details/product_details_service.dart';
import '../../../model/recomended_product_model.dart';
import '../../../data/netwok/my_cart/my_cart_service.dart';
import '../../../routes/app_pages.dart';


class ProductDetailsController extends GetxController {
  final ProductDetailsService _productDetailsService = ProductDetailsService();
  Rx<ProductData?> product = Rx<ProductData?>(null);
  RxBool isLoading = RxBool(false);
  RxBool isFavourite = RxBool(false);
  RxString selectColor = RxString('white');
  RxString selectedProductSize = RxString('S');

  Future<void> onAppInitialDataLoadFunction() async {
    try {
      final String productId = Get.arguments;
      fetchProductDetails(productId);
    } catch (e) {
      print("object $e");
    }
  }

  @override
  void onInit() {
    onAppInitialDataLoadFunction();
    super.onInit();

  }

  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading.value = true;
      final response = await _productDetailsService.getProductById(id);
      product.value = ProductData.fromJson(response);

      print(response);
    } catch (e) {
      // Handle error, you can display an error message
      print('Error fetching product details: $e');
    } finally {
      isLoading.value = false;
    }
  }




  Future<void> addToCartAndGoToCart() async {
    try {
      final productData = product.value;
      print("==========================>>>>>>>>>>>  ${product.value?.id} ===================== ");
      if (productData == null) return;
      final token = LocalStorage.token;
      if (token.isEmpty) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }
      final cartService = MyCartService();
      final payload = {
        'productId': productData.id,
        'quantity': 1,
        'color': selectColor.value,
        'size': selectedProductSize.value,
      };

      print("==========================>>>>>>>>>>>  ${payload} ===================== ");
      final success = await cartService.addToCart(token: token, cartData: payload);
      if (success) {
        Get.snackbar('Success', 'Product added to cart');
        Get.toNamed(Routes.myCart);
      } else {
        Get.snackbar('Error', 'Could not add product to cart');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar('Error', 'Could not add product to cart');
    }
  }
}
