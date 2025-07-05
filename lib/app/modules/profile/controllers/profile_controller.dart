import 'package:get/get.dart';
import '../../../data/netwok/profile/profile_service.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      // String? token = await storage.read(key: 'access_token');
      // if (token == null) {
      //   Get.snackbar("Error", "No access token found. Please login again.");
      //   isLoading.value = false;
      //   return;
      // }
      final profileData = await ProfileService.getProfile(token: "");
      if (profileData != null) {
        name.value = profileData['full_name'] ?? '-';
        email.value = profileData['email'] ?? '-';
      } else {
        Get.snackbar("Error", "Failed to load profile");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
