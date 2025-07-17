import 'package:get/get.dart';

import '../../../data/netwok/profile/data_privacy_service.dart';
import '../../../data/local/storage_service.dart';

class DataPrivacyController extends GetxController {
  var privacyPolicy = ''.obs; 
  final DataPrivacyService _dataPrivacyService = DataPrivacyService();

  // Fetch the privacy policy using the token from LocalStorage
  Future<void> fetchPrivacyPolicy() async {
    final token = LocalStorage.token;
    if (token.isNotEmpty) {
      privacyPolicy.value = await _dataPrivacyService.getPrivacyPolicy(token);
    } else {
      privacyPolicy.value = 'Authentication token is missing!';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }
}