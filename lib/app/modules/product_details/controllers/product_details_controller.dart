import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/add_to_cart_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';

import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/product_details/product_details_service.dart';
import '../../../model/recomended_product_model.dart';

class ProductDetailsController extends GetxController {
  final ProductDetailsService _productDetailsService = ProductDetailsService();

  // Existing observables
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

  // Order-related observables
  final RxBool isCreatingOrder = false.obs;
  final Rx<OrderData?> createdOrder = Rx<OrderData?>(null);
  final RxString orderErrorMessage = ''.obs;

  // Order form data
  final RxString selectedShop = ''.obs;
  final RxString shippingAddress = ''.obs;
  final RxString selectedPaymentMethod = ''.obs;
  final RxString selectedDeliveryOption = ''.obs;
  final RxString couponCode = ''.obs;

  // Order service instance
  OrderService? _orderService;

  @override
  void onInit() {
    super.onInit();
    onAppInitialDataLoadFunction();
    _initializeOrderService();
  }

  void _initializeOrderService() {
    final token = LocalStorage.token;
    if (token.isNotEmpty) {
      _orderService = OrderService(token);
    }
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

  // ============ ORDER CREATION METHODS ============

  /// Creates an order with the currently selected product
  Future<bool> createDirectOrder({
    required String shopId,
    required String shippingAddressText,
    required String paymentMethod,
    required String deliveryOption,
    String? coupon,
  }) async {
    final token = LocalStorage.token;
    final productId = product.value?.id ?? '';
    final variantId = selectedVariantId.value;
    final qty = selectedQuantity.value;
    final price = product.value?.basePrice ?? 0;
    final totalPrice = price * qty;

    // Validation
    if (token.isEmpty) {
      Get.snackbar('Error', 'Please login to create order');
      return false;
    }

    if (productId.isEmpty || variantId.isEmpty) {
      Get.snackbar('Error', 'Please select product options');
      return false;
    }

    if (!_validateOrderInput(
      shippingAddressText,
      paymentMethod,
      deliveryOption,
    )) {
      return false;
    }

    try {
      isCreatingOrder(true);
      orderErrorMessage('');

      // Initialize order service if not already done
      if (_orderService == null) {
        _orderService = OrderService(token);
      }

      // Create order products list
      final orderProducts = [
        OrderProduct(
          product: productId,
          variant: variantId,
          quantity: qty,
          totalPrice: totalPrice,
        ),
      ];

      // Create order request
      final orderRequest = OrderRequest(
        shop: shopId,
        products: orderProducts,
        coupon: coupon?.isNotEmpty == true ? coupon : null,
        shippingAddress: shippingAddressText,
        paymentMethod: paymentMethod,
        deliveryOptions: deliveryOption,
      );

      print('🔄 Creating order for product: ${product.value?.name}');

      final response = await _orderService!.createOrder(orderRequest);

      if (response.success) {
        createdOrder.value = response.data;
        Get.snackbar('Success', 'Order created successfully!');
        print('✅ Order created successfully: ${response.data?.id}');

        // Optional: Navigate to order confirmation screen
        // Get.toNamed('/order-confirmation', arguments: response.data);

        return true;
      } else {
        orderErrorMessage(response.message);
        Get.snackbar('Error', response.message);
        return false;
      }
    } on ApiException catch (e) {
      print('❌ API Error creating order: ${e.message}');
      orderErrorMessage(e.message);
      Get.snackbar('Error', e.message);
      return false;
    } catch (e) {
      print('❌ Unexpected error creating order: $e');
      orderErrorMessage('An unexpected error occurred');
      Get.snackbar('Error', 'Failed to create order: ${e.toString()}');
      return false;
    } finally {
      isCreatingOrder(false);
    }
  }

  /// Creates an order with multiple products (for cart checkout)
  Future<bool> createOrderFromProducts({
    required String shopId,
    required List<OrderProduct> products,
    required String shippingAddressText,
    required String paymentMethod,
    required String deliveryOption,
    String? coupon,
  }) async {
    final token = LocalStorage.token;

    if (token.isEmpty) {
      Get.snackbar('Error', 'Please login to create order');
      return false;
    }

    if (!_validateOrderInput(
      shippingAddressText,
      paymentMethod,
      deliveryOption,
    )) {
      return false;
    }

    if (products.isEmpty) {
      Get.snackbar('Error', 'No products selected for order');
      return false;
    }

    try {
      isCreatingOrder(true);
      orderErrorMessage('');

      if (_orderService == null) {
        _orderService = OrderService(token);
      }

      final orderRequest = OrderRequest(
        shop: shopId,
        products: products,
        coupon: coupon?.isNotEmpty == true ? coupon : null,
        shippingAddress: shippingAddressText,
        paymentMethod: paymentMethod,
        deliveryOptions: deliveryOption,
      );

      print('🔄 Creating order with ${products.length} products');

      final response = await _orderService!.createOrder(orderRequest);

      if (response.success) {
        createdOrder.value = response.data;
        Get.snackbar('Success', 'Order created successfully!');
        print('✅ Order created successfully: ${response.data?.id}');
        return true;
      } else {
        orderErrorMessage(response.message);
        Get.snackbar('Error', response.message);
        return false;
      }
    } on ApiException catch (e) {
      print('❌ API Error creating order: ${e.message}');
      orderErrorMessage(e.message);
      Get.snackbar('Error', e.message);
      return false;
    } catch (e) {
      print('❌ Unexpected error creating order: $e');
      orderErrorMessage('An unexpected error occurred');
      Get.snackbar('Error', 'Failed to create order: ${e.toString()}');
      return false;
    } finally {
      isCreatingOrder(false);
    }
  }

  /// Buy now functionality - creates order directly
  Future<void> buyNow({
    required String shopId,
    required String shippingAddressText,
    required String paymentMethod,
    required String deliveryOption,
    String? coupon,
  }) async {
    final success = await createDirectOrder(
      shopId: shopId,
      shippingAddressText: shippingAddressText,
      paymentMethod: paymentMethod,
      deliveryOption: deliveryOption,
      coupon: coupon,
    );

    if (success && createdOrder.value != null) {
      // Navigate to order confirmation or payment screen
      Get.toNamed('/order-confirmation', arguments: createdOrder.value);
    }
  }

  /// Validates order input data
  bool _validateOrderInput(
    String shippingAddress,
    String paymentMethod,
    String deliveryOption,
  ) {
    if (shippingAddress.trim().isEmpty) {
      Get.snackbar('Error', 'Shipping address is required');
      return false;
    }

    if (paymentMethod.trim().isEmpty) {
      Get.snackbar('Error', 'Please select a payment method');
      return false;
    }

    if (deliveryOption.trim().isEmpty) {
      Get.snackbar('Error', 'Please select a delivery option');
      return false;
    }

    return true;
  }

  /// Updates order form fields
  void updateShippingAddress(String address) {
    shippingAddress.value = address;
  }

  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void updateDeliveryOption(String option) {
    selectedDeliveryOption.value = option;
  }

  void updateCouponCode(String code) {
    couponCode.value = code;
  }

  void updateSelectedShop(String shop) {
    selectedShop.value = shop;
  }

  /// Clears order-related data
  void clearOrderData() {
    createdOrder.value = null;
    orderErrorMessage('');
    shippingAddress('');
    selectedPaymentMethod('');
    selectedDeliveryOption('');
    couponCode('');
    selectedShop('');
  }

  /// Gets the current product as OrderProduct
  OrderProduct? getCurrentProductAsOrderProduct() {
    if (product.value?.id == null || selectedVariantId.value.isEmpty) {
      return null;
    }

    return OrderProduct(
      product: product.value!.id,
      variant: selectedVariantId.value,
      quantity: selectedQuantity.value,
      totalPrice: product.value?.basePrice ?? 0,
    );
  }

  @override
  void onClose() {
    // Clean up resources
    clearOrderData();
    super.onClose();
  }
}
