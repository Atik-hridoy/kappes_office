import 'package:get/get.dart';
import '../../../data/netwok/store/store_service.dart';
import '../../../model/store.dart';

class StoreController extends GetxController {
  final StoreService _storeService = StoreService();

  Rx<Shop?> store = Rx<Shop?>(null);
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final storeId = Get.arguments;
    if (storeId != null && storeId is String) {
      fetchStoreDetails(storeId);
    }
  }

  void fetchStoreDetails(String storeId) async {
    print('[StoreController] Fetching store details for storeId: $storeId');
    isLoading.value = true;
    error.value = '';
    final result = await _storeService.fetchStoreDetails(storeId);
    if (result != null) {
      store.value = result;
    } else {
      error.value = 'Failed to fetch store details.';
    }
    isLoading.value = false;
  }
}