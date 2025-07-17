import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/product_details/product_details_service.dart';
import '../../../model/recomended_product_model.dart';


class ProductDetailsController extends GetxController {
  final ProductDetailsService _productDetailsService = ProductDetailsService();
  Rx<ProductData?> product = Rx<ProductData?>(null);
  RxBool isLoading = RxBool(false);
  RxBool isFavourite = RxBool(false);
  RxString selectColor = RxString('white');
  RxString selectedProductSize = RxString('S');

  Future<void> onAppInitialDataLoadFunction() async {
    try {
      // Fetching the productId from Get.arguments (passed from the view)
      final String productId = Get.arguments;
      print('📤 Fetching details for Product ID: $productId');
      await fetchProductDetails(productId);
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Failed to load product details');
    }
  }

  @override
  void onInit() {
    super.onInit();
    onAppInitialDataLoadFunction();  // Load data when the controller is initialized
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      print('🔄 Fetching product details...');
      isLoading.value = true;
      final response = await _productDetailsService.getProductById(id);
      print('✅ Product details fetched successfully');

      // Assuming you have a ProductData model to parse the response data
      product.value = ProductData.fromJson(response);  // Parse the fetched data into your model
      print('Product Details: ${product.value?.name}');  // Print the fetched product name
    } catch (e) {
      print('❌ Error fetching product details: $e');
      Get.snackbar('Error', 'Failed to fetch product details');
    } finally {
      isLoading.value = false;
    }
  }
}
