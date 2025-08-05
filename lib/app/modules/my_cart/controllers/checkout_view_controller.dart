// checkout_view_controller.dart
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/my_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';

class CheckoutViewController extends GetxController {
  // User Details
  final RxString userName = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString userAddress = ''.obs;

  // Editable Fields
  final RxString name = ''.obs;
  final RxString phone = ''.obs;
  final RxString address = ''.obs;

  // Delivery and Payment Options
  final List<String> deliveryOptions = [
    'Standard (5-7 days)',
    'Express (2-3 days)',
    'Overnight (1 day)',
  ];
  final RxString selectedDeliveryOption = 'Standard (5-7 days)'.obs;

  final List<String> paymentMethods = [
    'Cod (Cash on Delivery)',
    'Credit Card',
    'Online Payment',
  ];
  final RxString selectedPaymentMethod = 'Cod (Cash on Delivery)'.obs;

  // Selection Options
  final RxString couponCode = ''.obs;

  // UI State
  final RxBool isLoading = false.obs;
  final RxBool isEditingAddress = false.obs;
  final RxBool termsAccepted = false.obs;

  final RxBool isRemember = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    userName.value = LocalStorage.myName;
    userPhone.value = LocalStorage.phone;
    userAddress.value = LocalStorage.myAddress;

    name.value = userName.value;
    phone.value = userPhone.value;
    address.value = userAddress.value;
  }

  Future<void> saveUserData() async {
    await LocalStorage.setString(LocalStorageKeys.myName, userName.value);
    await LocalStorage.setString(LocalStorageKeys.myAddress, userAddress.value);
    await LocalStorage.setString(LocalStorageKeys.phone, userPhone.value);
  }

  void toggleAddressEditing() {
    isEditingAddress.toggle();
    if (!isEditingAddress.value) {
      saveAddress();
    }
  }

  void setDeliveryOption(String value) {
    selectedDeliveryOption.value = value;
  }

  void setPaymentMethod(String value) {
    selectedPaymentMethod.value = value;
  }

  void editShippingAddress({
    String? newName,
    String? newPhone,
    String? newAddress,
  }) {
    if (newName != null) name.value = newName;
    if (newPhone != null) phone.value = newPhone;
    if (newAddress != null) address.value = newAddress;
  }

  Future<void> saveAddress() async {
    try {
      await LocalStorage.setString(LocalStorageKeys.myName, name.value);
      await LocalStorage.setString(LocalStorageKeys.phone, phone.value);
      await LocalStorage.setString(LocalStorageKeys.myAddress, address.value);

      userName.value = name.value;
      userPhone.value = phone.value;
      userAddress.value = address.value;

      Get.snackbar('Success', 'Address updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save address');
    }
  }

  /// Handles full checkout logic, including cart extraction, order creation, and navigation
  Future<void> handleCheckout(
    BuildContext context,
    bool agreedToTnC,
    String? shopId,
  ) async {
    AppLogger.debug(
      'Checkout initiated. agreedToTnC: $agreedToTnC, shopId: ${shopId ?? 'null'}',
    );
    if (!agreedToTnC) {
      Get.snackbar(
        'Terms and Conditions',
        'You must agree to the terms and conditions before placing your order.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final args = Get.arguments;
    final List<OrderProduct> products =
        (args['products'] as List).cast<OrderProduct>();
    final String shopIdFromArgs = args['shopId'] ?? shopId ?? '';

    if (products.isEmpty) {
      Get.snackbar(
        'Order',
        'No products found for checkout.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    AppLogger.debug('Shop ID from args: $shopIdFromArgs');
    if (shopIdFromArgs.isEmpty) {
      Get.snackbar(
        'Order',
        'No shop ID found for checkout.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await createOrder(products, shopId ?? '');
      isLoading.value = false;
      if (kDebugMode) {
        AppLogger.success('Order creation success!');
      }
      Get.toNamed(Routes.checkoutSuccessfulView);
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        AppLogger.error('Order creation failed: $e');
      }
      Get.snackbar(
        'Order',
        'Order creation failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> createOrder(List<OrderProduct> products, String shopId) async {
    // Use MyCartController to get the cart items with their total price
    final cartController = Get.find<MyCartController>();
    final cartItems = cartController.cartData.value?.data?.items ?? [];
    // Build the products list with totalPrice for each product
    final orderProducts =
        cartItems
            .map(
              (item) => OrderProduct(
                product: item.productId?.id ?? '',
                variant: item.variantId?.id ?? '',
                quantity: item.variantQuantity,
                totalPrice: item.totalPrice,
              ),
            )
            .toList();
    // Use this list instead of the passed-in products
    products = orderProducts;
    // Validate required fields
    final userId = LocalStorage.userId;
    final token = LocalStorage.token;
    if (userId.isEmpty || token.isEmpty) {
      Get.snackbar('Error', 'User not logged in or token missing');
      return;
    }

    if (name.value.isEmpty || phone.value.isEmpty || address.value.isEmpty) {
      Get.snackbar('Error', 'Name, phone, and shipping address are required');
      return;
    }
    if (products.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty');
      return;
    }

    // Prepare order request
    final orderRequest = OrderRequest(
      shop: shopId,
      products: products,
      coupon: couponCode.value.isNotEmpty ? couponCode.value : null,
      shippingAddress: address.value,
      paymentMethod: parsePaymentMethod(selectedPaymentMethod.value),
      deliveryOptions: parseDeliveryOption(selectedDeliveryOption.value),
    );

    // Calculate and print total price
    final totalOrderPrice = products.fold<double>(
      0,
      (sum, p) => sum + (p.totalPrice),
    );
    AppLogger.info(
      '[Checkout] Total order price: \$${totalOrderPrice.toStringAsFixed(2)}',
    );

    isLoading(true);
    try {
      AppLogger.debug(
        '[Checkout] Creating order with payload: ${orderRequest.toJson()}',
      );

      final response = await OrderService(token).createOrder(orderRequest);

      AppLogger.debug("===============status by chironjit $response.body");

      AppLogger.debug(
        '[Checkout] OrderService response: ${response.toString()}',
      );
      if (response.success && response.data != null) {
        AppLogger.success(
          '[Checkout] Order successfully stored on backend. User ID: $userId',
        );
        AppLogger.data('[Checkout] Order Data: ${response.data}');
        // Ensure products is a List<Map<String, dynamic>> for safe navigation
        final productsList =
            (response.data?.products ?? [])
                // ignore: unnecessary_type_check
                .map((item) => item is OrderItem ? item.toJson() : item)
                .toList();
        AppLogger.debug(
          '[Checkout] Passing products to success view: type=${productsList.runtimeType}, value=$productsList',
        );
        Get.offNamed(
          Routes.checkoutSuccessfulView,
          arguments: {'orderData': response.data, 'products': productsList},
        );
      } else if (!response.success) {
        AppLogger.error(
          '[Checkout] Backend responded with error: ${response.message}',
        );
        Get.snackbar('Order Error', response.message);
      } else {
        AppLogger.error('[Checkout] Order response missing data!');
        Get.snackbar('Order Error', 'Order was not created. Try again.');
      }
    } catch (e, stack) {
      AppLogger.error('[Checkout] Exception while creating order: $e\n$stack');
      Get.snackbar('Order Error', 'Failed to create order: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  String parsePaymentMethod(String displayText) {
    if (displayText.contains('Cod')) return 'Cod';
    if (displayText.contains('Credit')) return 'Card';
    return 'Online';
  }

  String parseDeliveryOption(String displayText) {
    if (displayText.contains('Standard')) return 'Standard';
    if (displayText.contains('Express')) return 'Express';
    return 'Overnight';
  }
}
