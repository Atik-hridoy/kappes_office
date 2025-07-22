import 'package:canuck_mall/app/data/netwok/my_cart_my_order/create_order_service.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';
import 'package:get/get.dart';

class CheckoutViewController extends GetxController {
  // Observables for managing the order state and UI feedback
  var isOrderProcessing = false.obs;
  var orderResponse = Rx<OrderResponse?>(null);
  var errorMessage = "".obs;

  // Inputs for creating the order
  var shopId = ''.obs;
  var products = <OrderProduct>[].obs;
  var coupon = ''.obs;
  var shippingAddress = ''.obs;
  var paymentMethod = 'Cod'.obs;
  var deliveryOptions = 'Express'.obs;

  // Observable values for costs
  var itemCost = 449.97.obs; // Example item cost
  var shippingFee = 29.00.obs; // Example shipping fee
  var discount = 5.00.obs; // Example discount
  var finalAmount =
      (449.97 + 29.00 - 5.00)
          .obs; // Final amount (item cost + shipping fee - discount)

  // OrderService instance to handle API calls
  final OrderService orderService = OrderService('YOUR_AUTH_TOKEN');

  get isRemember => null; // Replace with your actual auth token

  // Method to update the delivery option
  void updateDeliveryOption(String value) {
    deliveryOptions.value = value;
    // Recalculate the final amount based on delivery option if needed
    _recalculateFinalAmount();
  }

  // Method to update the payment method
  void updatePaymentMethod(String value) {
    paymentMethod.value = value;
  }

  // Method to update coupon code
  void updateCoupon(String value) {
    coupon.value = value;
    // Recalculate discount based on coupon code (mocked in this example)
    if (coupon.value.isNotEmpty) {
      discount.value = 10.00; // Example discount change when coupon is applied
    } else {
      discount.value = 5.00; // Reset to default discount if coupon is empty
    }
    _recalculateFinalAmount(); // Recalculate the final amount after coupon update
  }

  // Method to recalculate the final amount
  void _recalculateFinalAmount() {
    finalAmount.value = itemCost.value + shippingFee.value - discount.value;
  }

  // Create Order function that will handle the API call to place an order
  Future<void> createOrder() async {
    try {
      isOrderProcessing.value = true; // Show loading state

      final orderRequest = OrderRequest(
        shop: shopId.value,
        products: products,
        coupon: coupon.value.isEmpty ? null : coupon.value,
        shippingAddress: shippingAddress.value,
        paymentMethod: paymentMethod.value,
        deliveryOptions: deliveryOptions.value,
      );

      final response = await orderService.createOrder(orderRequest);

      orderResponse.value = response; // Store the response
      isOrderProcessing.value = false; // Hide loading

      // Handle success response
      if (response.success) {
        Get.snackbar("Order Successful", "Your order has been placed.");
        // Navigate to success page or update the UI accordingly
      } else {
        errorMessage.value = response.message;
        Get.snackbar("Order Failed", response.message);
      }
    } catch (e) {
      isOrderProcessing.value = false;
      errorMessage.value = "An error occurred while creating the order.";
      Get.snackbar("Error", "Failed to place order. Please try again.");
    }
  }

  // Reset any order-related information, used after order placement or failure
  void resetOrderState() {
    isOrderProcessing.value = false;
    orderResponse.value = null;
    errorMessage.value = '';
    shopId.value = '';
    products.clear();
    coupon.value = '';
    shippingAddress.value = '';
    paymentMethod.value = 'Cod';
    deliveryOptions.value = 'Express';
    itemCost.value = 449.97;
    shippingFee.value = 29.00;
    discount.value = 5.00;
    finalAmount.value = 449.97 + 29.00 - 5.00;
  }
}
