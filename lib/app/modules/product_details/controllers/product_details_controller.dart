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
      // Get.arguments can be a product object or a product ID
      final arg = Get.arguments;
      if (arg is Map<String, dynamic>) {
        // Directly use the passed product object
        product.value = ProductData.fromJson(arg);
        print(
          '🟢 Showing product details from passed object: ${product.value?.name}',
        );
      } else if (arg is String) {
        // Fetch details by product ID
        print('📤 Fetching details for Product ID: $arg');
        await fetchProductDetails(arg);
      } else {
        print('❌ Invalid argument for product details: $arg');
        Get.snackbar('Error', 'Invalid product details argument');
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Failed to load product details');
    }
  }

  @override
  void onInit() {
    super.onInit();
    onAppInitialDataLoadFunction(); // Load data when the controller is initialized
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      print('🔄 Fetching product details...');
      isLoading.value = true;
      final response = await _productDetailsService.getProductById(id);
      print('✅ Product details fetched successfully');

      // Assuming you have a ProductData model to parse the response data
      product.value = ProductData.fromJson(
        response,
      ); // Parse the fetched data into your model
      print(
        'Product Details: ${product.value?.name}',
      ); // Print the fetched product name
    } catch (e) {
      print('❌ Error fetching product details: $e');
      Get.snackbar('Error', 'Failed to fetch product details');
    } finally {
      isLoading.value = false;
    }
  }
}
