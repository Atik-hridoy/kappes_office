import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/trade_service/trade_service.dart';

class TradesServicesController extends GetxController {
  RxList<Business> businesses = <Business>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVerifiedBusinesses();
  }

  Future<void> fetchVerifiedBusinesses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await TradeService.getAllVerifiedBusinesses();
      
      if (response.success) {
        businesses.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Error loading businesses: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshBusinesses() {
    fetchVerifiedBusinesses();
  }
}
