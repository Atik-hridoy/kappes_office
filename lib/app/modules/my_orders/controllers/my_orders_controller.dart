import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/get_order_service.dart';
import 'package:canuck_mall/app/model/get_my_order_model.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

class MyOrdersController extends GetxController {
  final GetOrderService _orderService = GetOrderService();

  // Ongoing orders state
  final Rx<OrderResponseModel?> _ongoingOrders = Rx<OrderResponseModel?>(null);
  final RxBool _ongoingIsLoading = false.obs;
  final RxBool _ongoingIsRefreshing = false.obs;
  final RxBool _ongoingIsLoadingMore = false.obs;
  final RxString _ongoingErrorMessage = ''.obs;
  final RxInt _ongoingCurrentPage = 1.obs;
  final RxInt _ongoingLimit = 10.obs;
  final RxBool _ongoingHasMoreData = true.obs;

  // Completed orders state
  final Rx<OrderResponseModel?> _completedOrders = Rx<OrderResponseModel?>(
    null,
  );
  final RxBool _completedIsLoading = false.obs;
  final RxString _completedErrorMessage = ''.obs;
  final RxInt _completedCurrentPage = 1.obs;
  final RxInt _completedLimit = 10.obs;
  final RxBool _completedHasMoreData = true.obs;

  // Auth
  final RxString _authToken = ''.obs;

  // Getters - Ongoing
  OrderResponseModel? get ongoingOrders => _ongoingOrders.value;
  bool get ongoingIsLoading => _ongoingIsLoading.value;
  bool get ongoingIsRefreshing => _ongoingIsRefreshing.value;
  bool get ongoingIsLoadingMore => _ongoingIsLoadingMore.value;
  String get ongoingErrorMessage => _ongoingErrorMessage.value;
  int get ongoingCurrentPage => _ongoingCurrentPage.value;
  bool get ongoingHasMoreData => _ongoingHasMoreData.value;
  int get ongoingTotalOrders => _ongoingOrders.value?.data.meta.total ?? 0;
  int get ongoingTotalPages => _ongoingOrders.value?.data.meta.totalPage ?? 0;
  List<OrderResult> get ongoingOrdersList =>
      _ongoingOrders.value?.data.result ?? [];

  // Getters - Completed
  OrderResponseModel? get completedOrders => _completedOrders.value;
  bool get completedIsLoading => _completedIsLoading.value;
  String get completedErrorMessage => _completedErrorMessage.value;
  int get completedCurrentPage => _completedCurrentPage.value;
  bool get completedHasMoreData => _completedHasMoreData.value;
  int get completedTotalOrders => _completedOrders.value?.data.meta.total ?? 0;
  int get completedTotalPages =>
      _completedOrders.value?.data.meta.totalPage ?? 0;
  List<OrderResult> get completedOrdersList =>
      _completedOrders.value?.data.result ?? [];

  void setAuthToken(String token) {
    _authToken.value = token;
  }

  @override
  void onInit() async {
    super.onInit();
    await _loadAuthToken();
    fetchOngoingOrders();
    fetchCompletedOrders();
  }

  @override
  void onClose() {
    _orderService.dispose();
    super.onClose();
  }

  // Load token
  Future<void> _loadAuthToken() async {
    await LocalStorage.getAllPrefData();
    final token = LocalStorage.token;
    print('Loaded token: $token');
    _authToken.value = token;
  }

  // Ongoing - Fetch
  Future<void> fetchOngoingOrders({bool isRefresh = false}) async {
    await _loadAuthToken();
    if (isRefresh) {
      _ongoingIsRefreshing.value = true;
      _ongoingCurrentPage.value = 1;
      _ongoingHasMoreData.value = true;
    } else {
      _ongoingIsLoading.value = true;
    }

    _ongoingErrorMessage.value = '';

    try {
      final result = await _orderService.getOrders(
        page: _ongoingCurrentPage.value,
        limit: _ongoingLimit.value,
        status: 'Pending',
        authToken: _authToken.value,
      );

      if (isRefresh) {
        _ongoingOrders.value = result;
      } else {
        final existing = _ongoingOrders.value?.data.result ?? [];
        final newList = [...existing, ...result.data.result];
        _ongoingOrders.value = OrderResponseModel(
          success: result.success,
          message: result.message,
          data: OrderData(meta: result.data.meta, result: newList),
        );
      }

      _ongoingHasMoreData.value =
          _ongoingCurrentPage.value < result.data.meta.totalPage;
      if (!isRefresh) _ongoingCurrentPage.value++;
    } catch (e) {
      _ongoingErrorMessage.value = e.toString();
      if (!isRefresh) _ongoingOrders.value = null;
    } finally {
      _ongoingIsLoading.value = false;
      _ongoingIsRefreshing.value = false;
    }
  }

  Future<void> loadMoreOngoingOrders() async {
    if (_ongoingIsLoadingMore.value || !_ongoingHasMoreData.value) return;

    _ongoingIsLoadingMore.value = true;

    try {
      final nextPage = _ongoingCurrentPage.value;
      final result = await _orderService.getOrders(
        page: nextPage,
        limit: _ongoingLimit.value,
        status: 'ongoing',
        authToken: _authToken.value,
      );

      final existing = _ongoingOrders.value?.data.result ?? [];
      final updated = [...existing, ...result.data.result];

      _ongoingOrders.value = OrderResponseModel(
        success: result.success,
        message: result.message,
        data: OrderData(meta: result.data.meta, result: updated),
      );

      _ongoingCurrentPage.value++;
      _ongoingHasMoreData.value =
          _ongoingCurrentPage.value < result.data.meta.totalPage;
    } catch (e) {
      print('Error loading more ongoing orders: $e');
    } finally {
      _ongoingIsLoadingMore.value = false;
    }
  }

  Future<void> refreshOngoingOrders() async {
    await fetchOngoingOrders(isRefresh: true);
  }

  // Completed - Fetch
  Future<void> fetchCompletedOrders({bool isRefresh = false}) async {
    await _loadAuthToken();

    if (isRefresh) {
      _completedCurrentPage.value = 1;
      _completedHasMoreData.value = true;
    }

    _completedIsLoading.value = true;
    _completedErrorMessage.value = '';

    try {
      final result = await _orderService.getOrders(
        page: _completedCurrentPage.value,
        limit: _completedLimit.value,
        status: 'active',
        authToken: _authToken.value,
      );

      if (isRefresh) {
        _completedOrders.value = result;
      } else {
        final existing = _completedOrders.value?.data.result ?? [];
        final newList = [...existing, ...result.data.result];
        _completedOrders.value = OrderResponseModel(
          success: result.success,
          message: result.message,
          data: OrderData(meta: result.data.meta, result: newList),
        );
      }

      _completedHasMoreData.value =
          _completedCurrentPage.value < result.data.meta.totalPage;
      if (!isRefresh) _completedCurrentPage.value++;
    } catch (e) {
      _completedErrorMessage.value = e.toString();
      if (!isRefresh) _completedOrders.value = null;
    } finally {
      _completedIsLoading.value = false;
    }
  }

  Future<void> loadMoreCompletedOrders() async {
    if (_completedIsLoading.value || !_completedHasMoreData.value) return;

    _completedIsLoading.value = true;

    try {
      final nextPage = _completedCurrentPage.value;
      final result = await _orderService.getOrders(
        page: nextPage,
        limit: _completedLimit.value,
        status: 'active',
        authToken: _authToken.value,
      );

      final existing = _completedOrders.value?.data.result ?? [];
      final updated = [...existing, ...result.data.result];

      _completedOrders.value = OrderResponseModel(
        success: result.success,
        message: result.message,
        data: OrderData(meta: result.data.meta, result: updated),
      );

      _completedCurrentPage.value++;
      _completedHasMoreData.value =
          _completedCurrentPage.value < result.data.meta.totalPage;
    } catch (e) {
      AppLogger.error('Error loading more completed orders: $e');
    } finally {
      _completedIsLoading.value = false;
    }
  }

  Future<void> refreshCompletedOrders() async {
    await fetchCompletedOrders(isRefresh: true);
  }

  Future<void> refreshAllOrders() async {
    await Future.wait([refreshOngoingOrders(), refreshCompletedOrders()]);
  }
}