import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ProductDetailsController extends GetxController {
  final Dio _dio = Dio();

  /// Reactive variables
  final Rxn<Map<String, dynamic>> product = Rxn<Map<String, dynamic>>();
  final Rxn<Map<String, dynamic>> shop = Rxn<Map<String, dynamic>>();

  final RxBool isFavourite = false.obs;
  final RxString selectColor = ''.obs;
  final RxString selectedProductSize = ''.obs;
  final RxBool isLoading = true.obs;

  late final String? productId;

  @override
  void onInit() {
    super.onInit();
    productId = Get.arguments;

    if (productId != null && productId!.isNotEmpty) {
      fetchProductById(productId!);
    } else {
      isLoading.value = false;
      Get.snackbar("Error", "Product ID is missing.");
    }
  }

  Future<void> fetchProductById(String id) async {
    isLoading.value = true;

    try {
      final url = "${AppUrls.baseUrl}/product/$id";
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data['success'] == true) {
        product.value = response.data['data'];

        /// ✅ Fetch related shop
        final shopId = product.value?['shopId']?['_id'];
        if (shopId != null) {
          await fetchShopById(shopId);
        }
      } else {
        final message = response.data['message'] ?? 'Unknown error';
        Get.snackbar("Error", message);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load product: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchShopById(String shopId) async {
    try {
      final url = "${AppUrls.baseUrl}/shop/$shopId";
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data['success'] == true) {
        shop.value = response.data['data'];
      } else {
        Get.snackbar("Error", "Failed to load shop");
      }
    } catch (e) {
      print("❌ Error fetching shop: $e");
    }
  }
}
