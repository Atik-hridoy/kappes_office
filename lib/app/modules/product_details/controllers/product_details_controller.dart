import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/product_details/product_details_service.dart';
import '../../../model/recomended_product_model.dart';


class ProductDetailsController extends GetxController {
  final ProductDetailsService _productDetailsService = ProductDetailsService();
  Rx<ProductData?> product = Rx<ProductData?>(null);
  RxBool isLoading = RxBool(true);
  RxBool isFavourite = RxBool(false);
  RxString selectColor = RxString('white');
  RxString selectedProductSize = RxString('S');


  @override
  void onInit() {
    super.onInit();
    final productId = Get.arguments as String;
    print('🔄 Initializing ProductDetailsController with product ID: $productId');
    if (productId.isNotEmpty) {
      fetchProductDetails(productId);
    } else {
      print('❌ No product ID provided');
      Get.back();
    }
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      print('🔄 Fetching product details for ID: $id');
      isLoading.value = true;
      final response = await _productDetailsService.getProductById(id);
      print('✅ Product details fetched successfully');

      product.value = ProductData.fromJson(response);
      print('📦 Product Name: ${product.value?.name}');
    } catch (e) {
      print('❌ Error fetching product details: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch product details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
