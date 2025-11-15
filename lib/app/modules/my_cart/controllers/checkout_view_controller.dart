// checkout_view_controller.dart
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/shipping_service.dart';
import 'package:canuck_mall/app/model/sheeping_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:canuck_mall/app/modules/home/controllers/home_controller.dart';
import 'package:canuck_mall/app/modules/payment/views/payment_webview.dart';

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
    userPhone.value = LocalStorage.phone.isNotEmpty ? LocalStorage.phone : LocalStorage.myPhone;
    userAddress.value = LocalStorage.myAddress;

    name.value = userName.value;
    phone.value = userPhone.value;
    address.value = userAddress.value;
    
    AppLogger.debug(
      '📱 [LoadUserData] Phone numbers: LocalStorage.phone="${LocalStorage.phone}", LocalStorage.myPhone="${LocalStorage.myPhone}", final phone.value="${phone.value}"',
      tag: 'CHECKOUT',
      error: 'Phone numbers: LocalStorage.phone="${LocalStorage.phone}", LocalStorage.myPhone="${LocalStorage.myPhone}", final phone.value="${phone.value}"',
    );
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
      AppLogger.debug(
        '🔄 [Checkout] About to call createOrder with ${products.length} products',
        tag: 'CHECKOUT',
        error: 'About to call createOrder with ${products.length} products',
      );
      
      await createOrder(products, shopId ?? '');
      
      AppLogger.debug(
        '✅ [Checkout] createOrder completed successfully',
        tag: 'CHECKOUT',
        error: 'createOrder completed successfully',
      );
      
      isLoading.value = false;
      if (kDebugMode) {
        AppLogger.success('Order creation success!');
      }
      // Navigation is handled inside createOrder() method
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
    AppLogger.debug(
      '🎯 [CreateOrder] Method started with ${products.length} products, shopId: $shopId',
      tag: 'CHECKOUT',
      error: 'Method started with ${products.length} products, shopId: $shopId',
    );
    
    // Get products from arguments instead of cart to avoid cart dependency
    final args = Get.arguments;
    if (args != null && args['products'] != null) {
      AppLogger.debug(
        '📦 [CreateOrder] Found products in arguments, processing...',
        tag: 'CHECKOUT',
        error: 'Found products in arguments, processing...',
      );
      final argProducts = args['products'] as List;
      AppLogger.debug(
        '🔍 [CreateOrder] Raw products from arguments: $argProducts',
        tag: 'CHECKOUT',
        error: 'Raw products from arguments: $argProducts',
      );
      
      products = argProducts.map((p) {
        AppLogger.debug(
          '🔍 [CreateOrder] Processing product: $p (type: ${p.runtimeType})',
          tag: 'CHECKOUT',
          error: 'Processing product: $p (type: ${p.runtimeType})',
        );
        
        // Handle both Map and OrderProduct objects
        if (p is Map<String, dynamic>) {
          final productId = p['product'] ?? p['productId'] ?? '';
          final variantId = p['variant'] ?? p['variantId'] ?? '';
          final quantity = p['quantity'] ?? 1;
          final totalPrice = (p['totalPrice'] ?? 0.0).toDouble();
          
          AppLogger.debug(
            '📦 [CreateOrder] Extracted: productId=$productId, variantId=$variantId, quantity=$quantity, totalPrice=$totalPrice',
            tag: 'CHECKOUT',
            error: 'Extracted: productId=$productId, variantId=$variantId, quantity=$quantity, totalPrice=$totalPrice',
          );
          
          return OrderProduct(
            product: productId,
            variant: variantId,
            quantity: quantity,
            totalPrice: totalPrice,
          );
        } else if (p is OrderProduct) {
          return p;
        } else {
          // Log unknown product type
          AppLogger.debug('⚠️ [CreateOrder] Unknown product type: ${p.runtimeType}', tag: 'CHECKOUT', error: 'Unknown product type: ${p.runtimeType}');
          return OrderProduct(
            product: '',
            variant: '',
            quantity: 1,
            totalPrice: 0.0,
          );
        }
      }).toList();
      AppLogger.debug(
        '📦 [CreateOrder] Processed ${products.length} products from arguments',
        tag: 'CHECKOUT',
        error: 'Processed ${products.length} products from arguments',
      );
    }
    
    // Validate required fields
    // Ensure all local storage data is loaded
    await LocalStorage.getAllPrefData();
    
    final userId = LocalStorage.userId;
    final token = LocalStorage.token;
    AppLogger.debug(
      '🔐 [CreateOrder] Validating credentials: userId.isEmpty=${userId.isEmpty}, token.isEmpty=${token.isEmpty}',
      tag: 'CHECKOUT',
      error: 'Validating credentials: userId.isEmpty=${userId.isEmpty}, token.isEmpty=${token.isEmpty}',
    );
    AppLogger.debug(
      '🔐 [CreateOrder] userId: $userId, token: ${token.isNotEmpty ? "${token.substring(0, 20)}..." : "empty"}',
      tag: 'CHECKOUT',
      error: 'userId: $userId, token: ${token.isNotEmpty ? "${token.substring(0, 20)}..." : "empty"}',
    );
    
    if (token.isEmpty) {
      AppLogger.debug('❌ [CreateOrder] Token missing - user not logged in', tag: 'CHECKOUT', error: 'Token missing - user not logged in');
      Get.snackbar('Error', 'Please login to create order');
      return;
    }

    AppLogger.debug(
      '📝 [CreateOrder] Validating form fields: name="${name.value}" (${name.value.length} chars), phone="${phone.value}" (${phone.value.length} chars), address="${address.value}" (${address.value.length} chars)',
      tag: 'CHECKOUT',
      error: 'Validating form fields: name="${name.value}" (${name.value.length} chars), phone="${phone.value}" (${phone.value.length} chars), address="${address.value}" (${address.value.length} chars)',
    );

    // Check if phone is still empty and try to reload from storage
    if (phone.value.isEmpty) {
      await LocalStorage.getAllPrefData();
      phone.value = LocalStorage.phone.isNotEmpty ? LocalStorage.phone : LocalStorage.myPhone;
      AppLogger.debug('🔄 [CreateOrder] Reloaded phone from storage: "${phone.value}"', tag: 'CHECKOUT', error: 'Reloaded phone from storage: "${phone.value}"');
    }
    
    if (name.value.isEmpty || phone.value.isEmpty || address.value.isEmpty) {
      AppLogger.debug('❌ [CreateOrder] Name, phone, and shipping address are required', tag: 'CHECKOUT', error: 'Name, phone, and shipping address are required');
      Get.snackbar('Error', 'Name, phone, and shipping address are required');
      return;
    }
    
    
    if (products.isEmpty) {
      AppLogger.debug('❌ [CreateOrder] Your cart is empty', tag: 'CHECKOUT', error: 'Your cart is empty');
      Get.snackbar('Error', 'Your cart is empty');
      return;
    }
    
    AppLogger.debug(
      '✅ [CreateOrder] All validations passed, proceeding with order creation',
      tag: 'CHECKOUT',
      error: 'All validations passed, proceeding with order creation',
    );

    // Prepare order request
    final shippingAddr = address.value;
        
    final orderRequest = OrderRequest(
      shop: shopId,
      products: products,
      coupon: couponCode.value.isNotEmpty ? couponCode.value : null,
      shippingAddress: shippingAddr,
      paymentMethod: 'Card', // Force Card payment to get payment URL
      deliveryOptions: parseDeliveryOption(selectedDeliveryOption.value),
    );
    
    AppLogger.debug(
      '💳 [CreateOrder] Forcing Card payment method to get payment URL',
      tag: 'CHECKOUT',
      error: 'Forcing Card payment method to get payment URL',
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
        '🚀 [Checkout] About to create OrderService and call createOrder',
        tag: 'CHECKOUT',
        error: 'About to create OrderService and call createOrder',
      );
      AppLogger.debug(
        '📋 [Checkout] Order request payload: ${orderRequest.toJson()}',
        tag: 'CHECKOUT',
        error: 'Order request payload: ${orderRequest.toJson()}',
      );
      AppLogger.debug(
        '🔑 [Checkout] Using token: ${token.substring(0, 20)}...',
        tag: 'CHECKOUT',
        error: 'Using token: ${token.substring(0, 20)}...',
      );

      final orderService = OrderService(token);
      AppLogger.debug(
        '🔧 [Checkout] OrderService created, calling createOrder...',
        tag: 'CHECKOUT',
        error: 'OrderService created, calling createOrder...',
      );
      
      final response = await orderService.createOrder(orderRequest);
      
      AppLogger.debug(
        '📨 [Checkout] Got response from OrderService',
        tag: 'CHECKOUT',
        error: 'Got response from OrderService',
      );

     
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
        
        // Check if payment URL is available
        final paymentUrl = response.data?.url;
        AppLogger.debug(
          '🔍 [Checkout] Checking payment URL: paymentUrl=$paymentUrl, isNull=${paymentUrl == null}, isEmpty=${paymentUrl?.isEmpty}', 
          tag: 'CHECKOUT', 
          error: 'Checking payment URL: paymentUrl=$paymentUrl, isNull=${paymentUrl == null}, isEmpty=${paymentUrl?.isEmpty}',
        );
        
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          AppLogger.debug('🌐 [Checkout] Payment URL found, redirecting to WebView: $paymentUrl', tag: 'CHECKOUT', error: 'Payment URL found, redirecting to WebView: $paymentUrl');
          // Navigate to payment WebView
          Get.to(() => PaymentWebView(url: paymentUrl));
        } else {
          // Fallback to success view if no payment URL
          final productsList =
              (response.data?.products ?? [])
                  // ignore: unnecessary_type_check
                  .map((item) => item is OrderItem ? item.toJson() : item)
                  .toList();
          AppLogger.debug(
            '[Checkout] No payment URL, going to success view',
            tag: 'CHECKOUT',
            error: 'No payment URL, going to success view',
          );
          Get.offNamed(
            Routes.checkoutSuccessfulView,
            arguments: {'orderData': response.data, 'products': productsList},
          );
        }
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
      rethrow; // Re-throw the exception so handleCheckout can catch it
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
