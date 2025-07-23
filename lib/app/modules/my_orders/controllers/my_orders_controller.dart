// Path: lib/app/modules/my_orders/controllers/my_orders_controller.dart
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/completeOrder.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/get_ongoingOrder_service.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart';

import 'package:get/get.dart';

class MyOrdersController extends GetxController {
  // --- Shared State ---
  final RxBool _isRefreshingAllOrders = false.obs;
  bool get isRefreshingAllOrders => _isRefreshingAllOrders.value;

  // --- Ongoing Orders State ---
  final Rx<GetMyOrder?> _ongoingOrders = Rx<GetMyOrder?>(null);
  final RxBool _isOngoingLoading = false.obs;
  final RxBool _isOngoingRefreshing = false.obs;
  final RxBool _isOngoingLoadingMore = false.obs;
  final RxString _ongoingErrorMessage = ''.obs;
  final RxInt _ongoingCurrentPage = 1.obs;
  final RxInt _ongoingLimit = 10.obs;
  final RxBool _ongoingHasMoreData = true.obs;

  // --- Completed Orders State ---
  final Rx<GetMyOrder?> _completedOrders = Rx<GetMyOrder?>(null);
  final RxBool _isCompletedLoading = false.obs;
  final RxBool _isCompletedRefreshing = false.obs;
  final RxBool _isCompletedLoadingMore = false.obs;
  final RxString _completedErrorMessage = ''.obs;
  final RxInt _completedCurrentPage = 1.obs;
  final RxInt _completedLimit = 10.obs;
  final RxBool _completedHasMoreData = true.obs;

  // --- Services ---
  final GetOngoingOrderService _ongoingOrderService = GetOngoingOrderService();
  final CompletedOrderService _completedOrderService = CompletedOrderService();

  // --- Ongoing Orders Getters ---
  GetMyOrder? get ongoingOrders => _ongoingOrders.value;
  bool get isOngoingLoading => _isOngoingLoading.value;
  bool get isOngoingRefreshing => _isOngoingRefreshing.value;
  bool get isOngoingLoadingMore => _isOngoingLoadingMore.value;
  String get ongoingErrorMessage => _ongoingErrorMessage.value;
  int get ongoingCurrentPage => _ongoingCurrentPage.value;
  bool get ongoingHasMoreData => _ongoingHasMoreData.value;
  List<Order> get ongoingOrdersList => _ongoingOrders.value?.data.result ?? [];

  // --- Completed Orders Getters ---
  GetMyOrder? get completedOrders => _completedOrders.value;
  bool get isCompletedLoading => _isCompletedLoading.value;
  bool get isCompletedRefreshing => _isCompletedRefreshing.value;
  bool get isCompletedLoadingMore => _isCompletedLoadingMore.value;
  String get completedErrorMessage => _completedErrorMessage.value;
  int get completedCurrentPage => _completedCurrentPage.value;
  bool get completedHasMoreData => _completedHasMoreData.value;
  List<Order> get completedOrdersList =>
      _completedOrders.value?.data.result ?? [];

  // --- Fetch Ongoing Orders ---
  Future<void> fetchOngoingOrders({bool isRefresh = false}) async {
    if (isRefresh) {
      _isOngoingRefreshing.value = true;
      _ongoingCurrentPage.value = 1;
      _ongoingHasMoreData.value = true;
    } else {
      _isOngoingLoading.value = true;
    }
    _ongoingErrorMessage.value = '';
    try {
      final result = await _ongoingOrderService.getOngoingOrders(
        page: _ongoingCurrentPage.value,
        limit: _ongoingLimit.value,
      );
      if (result.success) {
        _ongoingOrders.value = result;
        _ongoingHasMoreData.value =
            _ongoingCurrentPage.value < result.data.meta.totalPage;
        _ongoingErrorMessage.value = '';
      } else {
        _ongoingErrorMessage.value = result.message;
      }
    } catch (e) {
      _ongoingErrorMessage.value = e.toString();
    } finally {
      _isOngoingLoading.value = false;
      _isOngoingRefreshing.value = false;
    }
  }

  // --- Load More Ongoing Orders ---
  Future<void> loadMoreOngoingOrders() async {
    if (!_ongoingHasMoreData.value || _isOngoingLoadingMore.value) return;
    _isOngoingLoadingMore.value = true;
    try {
      _ongoingCurrentPage.value++;
      final result = await _ongoingOrderService.getOngoingOrders(
        page: _ongoingCurrentPage.value,
        limit: _ongoingLimit.value,
      );
      if (result.success && result.data.result.isNotEmpty) {
        final current = _ongoingOrders.value;
        _ongoingOrders.value = GetMyOrder(
          success: result.success,
          message: result.message,
          data: OrderData(
            meta: result.data.meta,
            result: [...(current?.data.result ?? []), ...result.data.result],
          ),
          errorMessages: result.errorMessages,
          statusCode: result.statusCode,
        );
        _ongoingHasMoreData.value =
            _ongoingCurrentPage.value < result.data.meta.totalPage;
      } else {
        _ongoingHasMoreData.value = false;
      }
    } catch (e) {
      _ongoingErrorMessage.value = e.toString();
    } finally {
      _isOngoingLoadingMore.value = false;
    }
  }

  // --- Fetch Completed Orders ---
  Future<void> fetchCompletedOrders({bool isRefresh = false}) async {
    if (isRefresh) {
      _isCompletedRefreshing.value = true;
      _completedCurrentPage.value = 1;
      _completedHasMoreData.value = true;
    } else {
      _isCompletedLoading.value = true;
    }
    _completedErrorMessage.value = '';
    try {
      final result = await _completedOrderService.getCompletedOrders(
        page: _completedCurrentPage.value,
        limit: _completedLimit.value,
      );
      if (result.success) {
        _completedOrders.value = result;
        _completedHasMoreData.value =
            _completedCurrentPage.value < result.data.meta.totalPage;
        _completedErrorMessage.value = '';
      } else {
        _completedErrorMessage.value = result.message;
      }
    } catch (e) {
      _completedErrorMessage.value = e.toString();
    } finally {
      _isCompletedLoading.value = false;
      _isCompletedRefreshing.value = false;
    }
  }

  // --- Load More Completed Orders ---
  Future<void> loadMoreCompletedOrders() async {
    if (!_completedHasMoreData.value || _isCompletedLoadingMore.value) return;
    _isCompletedLoadingMore.value = true;
    try {
      _completedCurrentPage.value++;
      final result = await _completedOrderService.getCompletedOrders(
        page: _completedCurrentPage.value,
        limit: _completedLimit.value,
      );
      if (result.success && result.data.result.isNotEmpty) {
        final current = _completedOrders.value;
        _completedOrders.value = GetMyOrder(
          success: result.success,
          message: result.message,
          data: OrderData(
            meta: result.data.meta,
            result: [...(current?.data.result ?? []), ...result.data.result],
          ),
          errorMessages: result.errorMessages,
          statusCode: result.statusCode,
        );
        _completedHasMoreData.value =
            _completedCurrentPage.value < result.data.meta.totalPage;
      } else {
        _completedHasMoreData.value = false;
      }
    } catch (e) {
      _completedErrorMessage.value = e.toString();
    } finally {
      _isCompletedLoadingMore.value = false;
    }
  }

  // --- Refresh All Orders ---
  Future<void> refreshAllOrders() async {
    _isRefreshingAllOrders.value = true;
    await Future.wait([
      fetchOngoingOrders(isRefresh: true),
      fetchCompletedOrders(isRefresh: true),
    ]);
    _isRefreshingAllOrders.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOngoingOrders();
    fetchCompletedOrders();
  }

  @override
  void onClose() {
    _ongoingOrderService.dispose();
    _completedOrderService.dispose();
    super.onClose();
  }
}
