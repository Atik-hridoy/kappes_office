// Path: lib/features/orders/presentation/controller/completed_orders_controller.dart
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/completeOrder.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart';
import 'package:get/get.dart';

class CompletedOrdersController extends GetxController {
  final CompletedOrderService _completedOrderService = CompletedOrderService();

  final Rx<GetMyOrder?> _completedOrders = Rx<GetMyOrder?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = RxString('');

  GetMyOrder? get completedOrders => _completedOrders.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    print('🚀 Initializing CompletedOrdersController...');
    fetchCompletedOrders(); // Fetch data when the controller is initialized
  }

  Future<void> fetchCompletedOrders() async {
    print('🔄 Fetching completed orders...');
    _isLoading.value = true;
    _errorMessage.value = ''; // Clear previous errors

    try {
      final result = await _completedOrderService.getCompletedOrders();
      print('📦 Completed orders fetched successfully!');
      _completedOrders.value = result as GetMyOrder?;
    } catch (e) {
      print('🚫 Error fetching completed orders: $e');
      _errorMessage.value = e.toString();
      _completedOrders.value = null;
    } finally {
      print('🔄 Fetching completed orders complete.');
      _isLoading.value = false;
    }
  }

  /// Helper to get the list of orders, or an empty list if not available
  List<Order> get getOrdersList {
    print('📝 Getting list of completed orders...');
    return _completedOrders.value?.data.result ?? [];
  }
}
