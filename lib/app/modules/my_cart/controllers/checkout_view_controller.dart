// checkout_view_controller.dart
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';

class CheckoutViewController extends GetxController {
  OrderRequest? _lastOrderRequest;
  String? _lastOrderUserId;

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
    if (shopIdFromArgs.isEmpty) {
      Get.snackbar(
        'Order',
        'No shop ID found for checkout.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await createOrder(products, shopId ?? '');
      if (kDebugMode) {
        print('✅ ====================>> Order creation success!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Order creation failed: $e');
      }
      Get.snackbar(
        'Order',
        'Order creation failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> createOrder(List<OrderProduct> products, String shopId) async {
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

    isLoading(true);
    try {
      print('[Checkout] Creating order with payload: ${orderRequest.toJson()}');

      final response = await OrderService(token).createOrder(orderRequest);

      print("===============status by chironjit $response.body");

      print('[Checkout] OrderService response: ${response.toString()}');
      if (response.success && response.data != null) {
        _lastOrderRequest = orderRequest;
        _lastOrderUserId = userId;
        print(
          '[Checkout] Order successfully stored on backend. User ID: $userId',
        );
        print('[Checkout] Order Data: ${response.data}');
        // Ensure products is a List<Map<String, dynamic>> for safe navigation
        final productsList =
            (response.data?.products ?? [])
                // ignore: unnecessary_type_check
                .map((item) => item is OrderItem ? item.toJson() : item)
                .toList();
        print(
          '[Checkout] Passing products to success view: type=${productsList.runtimeType}, value=$productsList',
        );
        Get.offNamed(
          Routes.checkoutSuccessfulView,
          arguments: {'orderData': response.data, 'products': productsList},
        );
      } else if (!response.success) {
        print('[Checkout] Backend responded with error: ${response.message}');
        Get.snackbar('Order Error', response.message);
      } else {
        print('[Checkout] Order response missing data!');
        Get.snackbar('Order Error', 'Order was not created. Try again.');
      }
    } catch (e, stack) {
      print('[Checkout] Exception while creating order: $e\n$stack');
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
