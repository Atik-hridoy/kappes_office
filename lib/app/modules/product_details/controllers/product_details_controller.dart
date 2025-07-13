import 'package:get/get.dart';
import '../../../data/netwok/product_details/product_details_service.dart';
import '../../../model/product_model.dart';

class ProductDetailsController extends GetxController {
  final ProductDetailsService _productDetailsService = ProductDetailsService();
  Rx<ProductData?> product = Rx<ProductData?>(null);
  RxBool isLoading = RxBool(false);
  RxBool isFavourite = RxBool(false);
  RxString selectColor = RxString('white');
  RxString selectedProductSize = RxString('S');

  @override
  void onInit() {
    super.onInit();
    // You can pass the product ID from the view, like `Get.arguments`
    final String productId = Get.arguments;
    fetchProductDetails(productId);
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading.value = true;
      final response = await _productDetailsService.getProductById(id);
      product.value = ProductData.fromJson(response);

      print(response) ;
    } catch (e) {
      // Handle error, you can display an error message
      print('Error fetching product details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
