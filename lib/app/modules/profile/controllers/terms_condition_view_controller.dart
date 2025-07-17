import 'package:get/get.dart';
// Import the TermsConditionsService
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/netwok/profile/terms_condition_service.dart'; // Import SharedPreferences
import '../../../data/local/storage_service.dart';

class TermsConditionsController extends GetxController {
  var termsConditions = ''.obs; // Observable for terms and conditions HTML
  final TermsConditionsService _termsConditionsService = TermsConditionsService();



  // Method to fetch terms and conditions using the token
  Future<void> fetchTermsConditions() async {
    final token = LocalStorage.token;  // Get the token from LocalStorage
    if (token.isNotEmpty) {
      termsConditions.value = await _termsConditionsService.getTermsConditions(token);
    } else {
      termsConditions.value = 'Authentication token is missing!';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTermsConditions();  // Fetch terms and conditions on controller init
  }
}
