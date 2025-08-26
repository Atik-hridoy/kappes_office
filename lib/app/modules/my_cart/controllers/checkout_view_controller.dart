// checkout_view_controller.dart
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/shipping_service.dart';
import 'package:canuck_mall/app/model/sheeping_model.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/my_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:canuck_mall/app/modules/home/controllers/home_controller.dart';

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
  final RxBool isCalculatingShipping = false.obs;
  
  // Shipping
  final ShippingService _shippingService = ShippingService();
  final RxDouble shippingFee = 0.0.obs;
  final Rx<ShippingData?> shippingData = Rx<ShippingData?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    _getInitialLocation();
    _loadShippingData();
  }

  Future<void> _loadShippingData() async {
    try {
      isLoading.value = true;
      final details = await _shippingService.getShippingDetails();
      shippingData.value = details.data;
      calculateShippingFee();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load shipping information');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> calculateShippingFee() async {
    if (shippingData.value == null || userAddress.value.isEmpty) {
      shippingFee.value = 0.0;
      return;
    }

    // Only proceed if the address has changed
    final currentAddress = userAddress.value;
    isCalculatingShipping.value = true;
    
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Debounce delay
      if (currentAddress != userAddress.value) return; // Address changed while waiting

      final address = currentAddress.toLowerCase();
      double newFee = 0.0;
      
      // Check for free shipping conditions first
      if (shippingData.value!.freeShipping.area?.any((area) => 
          address.contains(area.toLowerCase())) ?? false) {
        newFee = 0.0;
      } 
      // Check for central shipping
      else if (shippingData.value!.centralShipping.area?.any((area) => 
          address.contains(area.toLowerCase())) ?? false) {
        newFee = shippingData.value!.centralShipping.cost.toDouble();
      }
      // Check for country shipping
      else if (shippingData.value!.countryShipping.area?.any((area) => 
          address.contains(area.toLowerCase())) ?? false) {
        newFee = shippingData.value!.countryShipping.cost.toDouble();
      }
      // Default to worldwide shipping
      else {
        newFee = shippingData.value!.worldWideShipping.cost.toDouble();
      }
      
      // Only update if the fee has actually changed
      if (shippingFee.value != newFee) {
        shippingFee.value = newFee;
      }
    } finally {
      isCalculatingShipping.value = false;
    }
  }

  // Get initial location from HomeController
  void _getInitialLocation() {
    try {
      final homeController = Get.find<HomeController>();
      if (homeController.currentAddress.value.isNotEmpty) {
        address.value = homeController.currentAddress.value;
        userAddress.value = homeController.currentAddress.value;
        // Save to local storage for persistence
        LocalStorage.setString(LocalStorageKeys.myAddress, address.value);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting initial location from HomeController',
        error: e,
        context: {'stack': stackTrace.toString()}
      );
    }
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
      // Only update if address has actually changed
      if (userName.value != name.value ||
          userPhone.value != phone.value ||
          userAddress.value != address.value) {
            
        await LocalStorage.setString(LocalStorageKeys.myName, name.value);
        await LocalStorage.setString(LocalStorageKeys.phone, phone.value);
        await LocalStorage.setString(LocalStorageKeys.myAddress, address.value);

        userName.value = name.value;
        userPhone.value = phone.value;
        userAddress.value = address.value;
        
        // Recalculate shipping fee when address changes
        if (userAddress.value.isNotEmpty) {
          await calculateShippingFee();
        }

        Get.snackbar('Success', 'Address updated successfully');
      }
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
      tag: 'CHECKOUT',
      error: 'Checkout initiated. agreedToTnC: $agreedToTnC, shopId: ${shopId ?? 'null'}',
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
    AppLogger.debug('Shop ID from args: $shopIdFromArgs', error: shopIdFromArgs);
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
        AppLogger.error('Order creation failed: $e', error: 'Order creation failed: $e');
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
        tag: 'CHECKOUT',
        error: orderRequest.toJson(),
      );

      final response = await OrderService(token).createOrder(orderRequest);

     
      AppLogger.debug(
        '[Checkout] OrderService response: ${response.toString()}',
        tag: 'CHECKOUT',
        error: response.toString(),
      );
      if (response.success && response.data != null) {
        AppLogger.success(
          '[Checkout] Order successfully stored on backend. User ID: $userId',
        );
        AppLogger.data('[Checkout] Order Data: ${response.data}', description: 'Order Data', context: {'userId': userId});
        // Ensure products is a List<Map<String, dynamic>> for safe navigation
        final productsList =
            (response.data?.products ?? [])
                // ignore: unnecessary_type_check
                .map((item) => item is OrderItem ? item.toJson() : item)
                .toList();
        AppLogger.debug(
          '[Checkout] Passing products to success view: type=${productsList.runtimeType}, value=$productsList',
          tag: 'CHECKOUT',
          error: productsList.runtimeType,
        );
        Get.offNamed(
          Routes.checkoutSuccessfulView,
          arguments: {'orderData': response.data, 'products': productsList},
        );
      } else if (!response.success) {
        AppLogger.error(
          '[Checkout] Backend responded with error: ${response.message}',
          error: 'Backend responded with error: ${response.message}',
        );
        Get.snackbar('Order Error', response.message);
      } else {
        AppLogger.error('[Checkout] Order response missing data!', error: 'Order response missing data!');
        Get.snackbar('Order Error', 'Order was not created. Try again.');
      }
    } catch (e, stack) {
      AppLogger.error('[Checkout] Exception while creating order: $e\n$stack', error: 'Exception while creating order: $e\n$stack');
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
