// checkout_view_controller.dart
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
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
    'Standard (5-7 days)', // maps to 'Standard'
    'Express (2-3 days)', // maps to 'Express'
    'Overnight (1 day)', // maps to 'Overnight'
  ];
  final RxString selectedDeliveryOption = 'Standard (5-7 days)'.obs;

  final List<String> paymentMethods = [
    'Cod (Cash on Delivery)', // maps to 'Cod'
    'Credit Card', // maps to 'Card'
    'Online Payment', // maps to 'Online'
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

      // Refresh from storage
      userName.value = name.value;
      userPhone.value = phone.value;
      userAddress.value = address.value;

      Get.snackbar('Success', 'Address updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save address');
    }
  }

  Future<void> createOrder(List<OrderProduct> products, String shopId) async {
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
      final orderRequest = OrderRequest(
        shop: shopId,
        products: products,
        coupon: couponCode.value.isNotEmpty ? couponCode.value : null,
        shippingAddress: address.value,
        paymentMethod: parsePaymentMethod(selectedPaymentMethod.value),
        deliveryOptions: parseDeliveryOption(selectedDeliveryOption.value),
      );
      final response = await OrderService(
        LocalStorage.token,
      ).createOrder(orderRequest);
      if (response.success) {
        Get.offNamed(Routes.checkoutSuccessfulView, arguments: response.data);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: [31m${e.toString()}[0m');
    } finally {
      isLoading(false);
    }
  }

  /// Parses the payment method from the given display text.
  ///
  /// This method checks if the provided `displayText` contains certain keywords
  /// and returns the corresponding payment method:
  /// - Returns 'Cod' if `displayText` contains 'Cod'
  /// - Returns 'Card' if `displayText` contains 'Credit'
  /// - Returns 'Online' if no known option is found
  ///
  /// - Parameter displayText: The text to parse for a payment method.
  /// - Returns: A string representing the payment method.

  String parsePaymentMethod(String displayText) {
    if (displayText.contains('Cod')) return 'Cod';
    if (displayText.contains('Credit')) return 'Card';
    return 'Online';
  }

  /// Parses the delivery option from the given display text.
  ///
  /// This method checks if the provided `displayText` contains certain keywords
  /// and returns the corresponding delivery option:
  /// - Returns 'Standard' if `displayText` contains 'Standard'
  /// - Returns 'Express' if `displayText` contains 'Express'
  /// - Returns 'Overnight' if no known option is found
  ///
  /// - Parameter displayText: The text to parse for a delivery option.
  /// - Returns: A string representing the delivery option.

  String parseDeliveryOption(String displayText) {
    if (displayText.contains('Standard')) return 'Standard';
    if (displayText.contains('Express')) return 'Express';
    return 'Overnight';
  }
}
