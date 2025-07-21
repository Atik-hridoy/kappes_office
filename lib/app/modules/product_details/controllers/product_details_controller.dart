import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart/add_to_cart_service.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/product_details/product_details_service.dart';
import '../../../model/recomended_product_model.dart';

class ProductDetailsController extends GetxController {
  final ProductDetailsService _productDetailsService = ProductDetailsService();
  final Rx<ProductData?> product = Rx<ProductData?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFavourite = false.obs;
  final RxString selectColor = ''.obs;
  final RxString selectedProductSize = ''.obs;
  final RxInt selectedQuantity = 1.obs;
  final RxString selectedVariantId = ''.obs;
  final RxBool isAddingToCart = false.obs;
  final RxList<String> availableColors = <String>[].obs;
  final RxList<String> availableSizes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    onAppInitialDataLoadFunction();
  }

  Future<void> onAppInitialDataLoadFunction() async {
    try {
      final arg = Get.arguments;

      if (arg is Map<String, dynamic>) {
        product.value = ProductData.fromJson(arg);
        _initializeVariantData();
        print(
          '🟢 Showing product details from passed object: ${product.value?.name}',
        );
      } else if (arg is String) {
        print('📤 Fetching details for Product ID: $arg');
        await fetchProductDetails(arg);
      } else {
        throw ArgumentError('Invalid product details argument');
      }
    } catch (e) {
      print("Error loading product details: $e");
      Get.snackbar('Error', 'Failed to load product details');
      rethrow;
    }
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading(true);
      print('🔄 Fetching product details...');

      final response = await _productDetailsService.getProductById(id);
      product.value = ProductData.fromJson(response);
      _initializeVariantData();

      print('✅ Product details fetched successfully: ${product.value?.name}');
    } catch (e) {
      print('❌ Error fetching product details: $e');
      Get.snackbar('Error', 'Failed to fetch product details');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  void _initializeVariantData() {
    if (product.value?.productVariantDetails == null ||
        product.value!.productVariantDetails.isEmpty) {
      return;
    }

    // Extract unique colors and sizes
    final variants = product.value!.productVariantDetails;
    availableColors.value =
        variants.map((v) => v.variantId.color.name).toSet().toList();

    availableSizes.value =
        variants.map((v) => v.variantId.size).toSet().toList();

    // Set default selections
    selectColor.value = availableColors.firstOrNull ?? '';
    selectedProductSize.value = availableSizes.firstOrNull ?? '';

    // Find and set corresponding variant ID
    _updateSelectedVariantId();
  }

  void _updateSelectedVariantId() {
    if (product.value?.productVariantDetails == null) return;

    final selectedVariant = product.value!.productVariantDetails.firstWhere(
      (v) =>
          v.variantId.color.name == selectColor.value &&
          v.variantId.size == selectedProductSize.value,
      orElse: () => product.value!.productVariantDetails.first,
    );

    selectedVariantId.value = selectedVariant.variantId.id;
  }

  void updateSelectedColor(String color) {
    selectColor.value = color;
    _updateSelectedVariantId();
  }

  void updateSelectedSize(String size) {
    selectedProductSize.value = size;
    _updateSelectedVariantId();
  }

  Future<void> addProductToCart() async {
    final token = LocalStorage.token;
    final productId = product.value?.id ?? '';
    final variantId = selectedVariantId.value;

    if (token.isEmpty) {
      Get.snackbar('Error', 'Please login to add items to cart');
      return;
    }

    if (productId.isEmpty || variantId.isEmpty) {
      Get.snackbar('Error', 'Please select product options');
      return;
    }

    try {
      isAddingToCart(true);

      final response = await CartService().addToCart(
        token: token,
        productId: productId,
        variantId: variantId,
        quantity: selectedQuantity.value,
      );

      Get.snackbar('Success', response.message);

      // Optional: Update cart count in your app state
      // Get.find<CartController>().refreshCartCount();
    } catch (e) {
      print('❌ Error adding to cart: $e');
      Get.snackbar('Error', 'Failed to add to cart: ${e.toString()}');
    } finally {
      isAddingToCart(false);
    }
  }

  void toggleFavorite() async {
    try {
      // Implement your favorite logic here
      isFavourite.toggle();

      // Example: Call API to update favorite status
      // await _productDetailsService.toggleFavorite(
      //   productId: product.value!.id,
      //   isFavorite: isFavourite.value,
      // );

      Get.snackbar(
        isFavourite.value ? 'Added to favorites' : 'Removed from favorites',
        '',
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      isFavourite.toggle(); // Revert on error
      print('❌ Error toggling favorite: $e');
    }
  }
}
