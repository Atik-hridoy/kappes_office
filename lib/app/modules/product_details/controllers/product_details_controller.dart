import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/add_to_cart_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
import 'package:canuck_mall/app/data/netwok/product_details/product_details_service.dart';
import 'package:canuck_mall/app/data/netwok/message/create_chat_serveice.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:canuck_mall/app/model/message_and_chat/create_chat_model.dart';
import 'package:canuck_mall/app/model/recomended_product_model.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/utils/log/error_log.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  // Services
  final CreateChatToSellerService chatService = CreateChatToSellerService();
  final ProductDetailsService _productDetailsService = ProductDetailsService();
  OrderService? _orderService;

  // Observables
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
        AppLogger.info('Showing product details from passed object: ${product.value?.name}');
      } else if (arg is String) {
        AppLogger.info('Fetching details for Product ID: $arg');
        await fetchProductDetails(arg);
      } else {
        throw ArgumentError('Invalid product details argument');
      }
    } catch (e) {
      AppLogger.error('Error loading product details: $e', error: 'Error loading product details: $e');
      Get.snackbar('Error', 'Failed to load product details');
      rethrow;
    }
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading(true);
      AppLogger.info('Fetching product details...');
      final response = await _productDetailsService.getProductById(id);
      product.value = ProductData.fromJson(response);
      _initializeVariantData();
      AppLogger.info('Product details fetched successfully: ${product.value?.name}');
    } catch (e) {
      AppLogger.error('Error fetching product details: $e', error: 'Error fetching product details: $e');
      Get.snackbar('Error', 'Failed to fetch product details');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  void _initializeVariantData() {
    if (product.value?.productVariantDetails == null || product.value!.productVariantDetails.isEmpty) {
      return;
    }

    final variants = product.value!.productVariantDetails;
    availableColors.value = variants.map((v) => v.variantId.color.name).toSet().toList();
    availableSizes.value = variants.map((v) => v.variantId.size).toSet().toList();

    selectColor.value = availableColors.firstOrNull ?? '';
    selectedProductSize.value = availableSizes.firstOrNull ?? '';
    _updateSelectedVariantId();
  }

  void _updateSelectedVariantId() {
    if (product.value?.productVariantDetails == null) return;

    final selectedVariant = product.value!.productVariantDetails.firstWhere(
      (v) => v.variantId.color.name == selectColor.value && v.variantId.size == selectedProductSize.value,
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
      AppLogger.info('Add to cart response: ${response.data}');
      Get.snackbar('Success', response.message);
    } catch (e) {
      ErrorLogger.logCaughtError(e, StackTrace.current, tag: 'ADD_TO_CART_ERROR');
      Get.snackbar('Error', 'Failed to add to cart: ${e.toString()}');
    } finally {
      isAddingToCart(false);
    }
  }

  void toggleFavorite() async {
    try {
      isFavourite.toggle();
      Get.snackbar(
        isFavourite.value ? 'Added to favorites' : 'Removed from favorites',
        '',
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      isFavourite.toggle();
      ErrorLogger.logCaughtError(e, StackTrace.current, tag: 'TOGGLE_FAVORITE_ERROR');
    }
  }

  // Chat creation
  Future<void> handleCreateChat({required String shopId}) async {
    try {
      if (!LocalStorage.isLogIn) {
        Get.snackbar('Error', 'Please login to start a chat');
        return;
      }

      final userId = LocalStorage.userId;
      final userFullName = LocalStorage.myName.isNotEmpty ? LocalStorage.myName : 'User';
      final userEmail = LocalStorage.myEmail;
      final userPhone = LocalStorage.phone;

      AppLogger.info('Creating chat for user: $userId, Shop ID: $shopId');

      String correctedShopId = shopId.startsWith('shop_') ? shopId.replaceFirst('shop_', '') : shopId;

      final chatData = ChatData(
        id: '',
        participants: [
          Participant(
            id: userId,
            participantId: ParticipantId(
              id: userId,
              fullName: userFullName,
              role: 'USER',
              email: userEmail,
              phone: userPhone,
              verified: true,
              isDeleted: false,
            ),
            participantType: 'User',
          ),
          Participant(
            id: correctedShopId,
            participantId: ParticipantId(
              id: correctedShopId,
              fullName: product.value?.shop.name ?? 'Shop',
              role: 'Shop',
              email: '',
              phone: '',
              verified: true,
              isDeleted: false,
            ),
            participantType: 'Shop',
          ),
        ],
        status: true,
      );

      final response = await chatService.createChat(chatData);

      if (response.success) {
        final chatId = response.data.id;
        AppLogger.info('Chat created successfully with ID: $chatId');
        Get.toNamed(
          Routes.chattingView,
          arguments: {
            'chatId': chatId,
            'shopId': correctedShopId,
            'shopName': product.value?.shop.name ?? 'Shop',
          },
        );
      } else {
        Get.snackbar('Error', 'Failed to create chat: ${response.message}');
      }
    } catch (e) {
      ErrorLogger.logCaughtError(e, StackTrace.current, tag: 'CHAT_ERROR');
      Get.snackbar('Error', 'An error occurred while starting the chat: $e');
    }
  }

  // Order creation methods
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

    if (token.isEmpty) {
      Get.snackbar('Error', 'Please login to create order');
      return false;
    }

    if (productId.isEmpty || variantId.isEmpty) {
      Get.snackbar('Error', 'Please select product options');
      return false;
    }

    if (!_validateOrderInput(shippingAddressText, paymentMethod, deliveryOption)) {
      return false;
    }

    try {
      isCreatingOrder(true);
      orderErrorMessage('');

      _orderService ??= OrderService(token);

      final orderProducts = [
        OrderProduct(
          product: productId,
          variant: variantId,
          quantity: qty,
          totalPrice: totalPrice,
        ),
      ];

      final orderRequest = OrderRequest(
        shop: shopId,
        products: orderProducts,
        coupon: coupon?.isNotEmpty == true ? coupon : null,
        shippingAddress: shippingAddressText,
        paymentMethod: paymentMethod,
        deliveryOptions: deliveryOption,
      );

      final response = await _orderService!.createOrder(orderRequest);

      if (response.success) {
        createdOrder.value = response.data;
        Get.snackbar('Success', 'Order created successfully!');
        AppLogger.info('Order created successfully: ${response.data?.id}');
        return true;
      } else {
        orderErrorMessage(response.message);
        Get.snackbar('Error', response.message);
        return false;
      }
    } catch (e) {
      ErrorLogger.logCaughtError(e, StackTrace.current, tag: 'UNEXPECTED_ERROR');
      orderErrorMessage('An unexpected error occurred');
      Get.snackbar('Error', 'Failed to create order: ${e.toString()}');
      return false;
    } finally {
      isCreatingOrder(false);
    }
  }

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

  @override
  void onClose() {
    clearOrderData();
    super.onClose();
  }

  void clearOrderData() {
    createdOrder.value = null;
    orderErrorMessage('');
    shippingAddress('');
    selectedPaymentMethod('');
    selectedDeliveryOption('');
    couponCode('');
    selectedShop('');
  }
}
