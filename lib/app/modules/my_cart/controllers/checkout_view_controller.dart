// checkout_view_controller.dart
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
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

  Future<void> createOrder(List<OrderProduct> products, String shopId) async {
    final userId = LocalStorage.userId; // Ensure this is set in LocalStorage
    final token = LocalStorage.token;
    // Prevent duplicate order
    final orderRequest = OrderRequest(
      shop: shopId,
      products: products,
      coupon: couponCode.value.isNotEmpty ? couponCode.value : null,
      shippingAddress: address.value,
      paymentMethod: parsePaymentMethod(selectedPaymentMethod.value),
      deliveryOptions: parseDeliveryOption(selectedDeliveryOption.value),
    );
    if (_lastOrderRequest != null && _lastOrderRequest == orderRequest && _lastOrderUserId == userId) {
      print('Order already placed with these credentials and data. Skipping order creation.');
      Get.snackbar('Info', 'Order already placed with these credentials and data.');
      return;
    }

    if (!termsAccepted.value) {
      Get.snackbar('Error', 'Please accept terms and conditions');
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
    try {
      isLoading(true);
      final response = await OrderService(token).createOrder(orderRequest);
      if (response.success) {
        _lastOrderRequest = orderRequest;
        _lastOrderUserId = userId;
        print('Order stored on backend:');
        print('User ID: $userId');
        print('Order Data: \\${response.data?.toString()}');
        print('Order Request: \\${orderRequest.toJson()}');
        Get.offNamed(Routes.checkoutSuccessfulView, arguments: response.data);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: ${e.toString()}');
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
