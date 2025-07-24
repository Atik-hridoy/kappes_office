// Path: lib/features/orders/presentation/controller/ongoing_orders_controller.dart
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/get_ongoingOrder_service.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart';
import 'package:get/get.dart'; // Import GetX

class OngoingOrdersController extends GetxController {
  final GetOngoingOrderService _orderService = GetOngoingOrderService();

  // Rx variables for reactive state
  final Rx<GetMyOrder?> _ongoingOrders = Rx<GetMyOrder?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxString _errorMessage = RxString('');
  final RxString _authToken = RxString('');

  // Pagination variables
  final RxInt _currentPage = 1.obs;
  final RxInt _limit = 10.obs;
  final RxBool _hasMoreData = true.obs;

  // Getters to expose state to the UI
  GetMyOrder? get ongoingOrders => _ongoingOrders.value;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String get errorMessage => _errorMessage.value;
  int get currentPage => _currentPage.value;
  bool get hasMoreData => _hasMoreData.value;

  // Get total count and pagination info
  int get totalOrders => _ongoingOrders.value?.data.meta.total ?? 0;
  int get totalPages => _ongoingOrders.value?.data.meta.totalPage ?? 0;

  // Constructor: Fetch data immediately when controller is initialized
  @override
  void onInit() {
    super.onInit();
    print('🚀 Initializing OngoingOrdersController...');
    print('🔄 Fetching ongoing orders on initialization...');
    fetchOngoingOrders();
  }

  @override
  void onClose() {
    // Clean up resources
    _orderService.dispose();
    super.onClose();
  }

  /// Sets the authentication token for API requests
  void setAuthToken(String token) {
    _authToken.value = token;
    print('🔐 Auth token updated');
  }

  /// Fetches ongoing orders from the API (first page or refresh)
  /// Updates loading state, error messages, and order data.
  Future<void> fetchOngoingOrders({bool isRefresh = false}) async {
    if (isRefresh) {
      print('🔄 Refreshing ongoing orders...');
      _isRefreshing.value = true;
      _currentPage.value = 1;
      _hasMoreData.value = true;
    } else {
      print('🔄 Fetching ongoing orders...');
      _isLoading.value = true;
    }

    _errorMessage.value = ''; // Clear previous errors

    try {
      final result = await _orderService.getOngoingOrders(
        page: _currentPage.value,
        limit: _limit.value,
        authToken: _authToken.value.isNotEmpty ? _authToken.value : null,
      );

      if (result.success) {
        print('📦 Ongoing orders fetched successfully!');
        print('📊 Total orders: ${result.data.meta.total}');

        if (isRefresh) {
          // Replace data on refresh
          _ongoingOrders.value = result;
        } else {
          // Set initial data
          _ongoingOrders.value = result;
        }

        // Update pagination state
        _hasMoreData.value = _currentPage.value < result.data.meta.totalPage;

        // Clear error message on success
        _errorMessage.value = '';
      } else {
        // Handle API error response
        print('🚫 API returned error: ${result.message}');
        _errorMessage.value = result.message;

        if (isRefresh) {
          // Keep existing data on refresh error
        } else {
          _ongoingOrders.value = null;
        }
      }
    } catch (e) {
      print('🚫 Error fetching ongoing orders: $e');
      _errorMessage.value = e.toString();

      if (!isRefresh) {
        _ongoingOrders.value = null;
      }
    } finally {
      print('🔄 Fetching ongoing orders complete.');
      _isLoading.value = false;
      _isRefreshing.value = false;
    }
  }

  /// Loads more orders (pagination)
  Future<void> loadMoreOrders() async {
    if (_isLoadingMore.value || !_hasMoreData.value) {
      print('⏸️ Load more skipped - already loading or no more data');
      return;
    }

    print('📄 Loading more orders (page ${_currentPage.value + 1})...');
    _isLoadingMore.value = true;

    try {
      final nextPage = _currentPage.value + 1;
      final result = await _orderService.getOngoingOrders(
        page: nextPage,
        limit: _limit.value,
        authToken: _authToken.value.isNotEmpty ? _authToken.value : null,
      );

      if (result.success && result.data.result.isNotEmpty) {
        print('📦 More orders loaded successfully!');

        // Append new orders to existing list
        final currentOrders = _ongoingOrders.value?.data.result ?? [];
        final newOrders = [...currentOrders, ...result.data.result];

        // Update the orders with combined data
        _ongoingOrders.value = GetMyOrder(
          success: result.success,
          message: result.message,
          data: OrderData(meta: result.data.meta, result: newOrders),
          errorMessages: result.errorMessages,
          statusCode: result.statusCode,
        );

        _currentPage.value = nextPage;
        _hasMoreData.value = nextPage < result.data.meta.totalPage;
      } else {
        print('� No more orders to load');
        _hasMoreData.value = false;
      }
    } catch (e) {
      print('🚫 Error loading more orders: $e');
      // Don't update error message for load more failures
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Refreshes the orders list (pull to refresh)
  Future<void> refreshOrders() async {
    await fetchOngoingOrders(isRefresh: true);
  }

  /// Retries fetching orders (for error states)
  Future<void> retryFetch() async {
    print('🔄 Retrying fetch...');
    await fetchOngoingOrders();
  }

  /// Helper to get the list of orders, or an empty list if not available
  List<Order> get getOrdersList {
    print('📝 Getting list of ongoing orders...');
    return _ongoingOrders.value?.data.result ?? [];
  }

  /// Gets a specific order by ID
  Order? getOrderById(String orderId) {
    return getOrdersList.firstWhereOrNull((order) => order.id == orderId);
  }

  /// Checks if there are any orders
  bool get hasOrders => getOrdersList.isNotEmpty;

  /// Gets orders count
  int get ordersCount => getOrdersList.length;

  /// Filters orders by status (additional client-side filtering if needed)
  List<Order> getOrdersByStatus(String status) {
    return getOrdersList
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  /// Gets orders by payment status
  List<Order> getOrdersByPaymentStatus(String paymentStatus) {
    return getOrdersList
        .where(
          (order) =>
              order.paymentStatus.toLowerCase() == paymentStatus.toLowerCase(),
        )
        .toList();
  }

  /// Clears all data and resets state
  void clearData() {
    _ongoingOrders.value = null;
    _errorMessage.value = '';
    _currentPage.value = 1;
    _hasMoreData.value = true;
    print('🧹 Controller data cleared');
  }
}
