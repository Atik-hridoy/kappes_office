import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/profile/profile_view_get_service.dart';

class ProfileController extends GetxController {
  // User profile data
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString profileImage = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  late final ProfileViewGetService _profileService;

  @override
  void onInit() {
    super.onInit();
    // You may want to fetch token from storage here
    _profileService = ProfileViewGetService(
      baseUrl: 'http://10.0.60.110:7000',
      // token: 'your_token',
    );
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await _profileService.getProfileData();
      name.value = data['name'] ?? '';
      email.value = data['email'] ?? '';
      profileImage.value = data['profileImage'] ?? '';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
    // Add logout logic here
  }
}
