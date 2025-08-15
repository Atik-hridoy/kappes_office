import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/profile/profile_view_get_service.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  var fullName = ''.obs;
  var email = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var profileImageUrl = ''.obs; // network image or absolute path for avatar

  @override
  void onInit() {
    super.onInit();
    // Ensure we always refresh when the controller is created (i.e., when entering the view)
    fetchProfile();
  }

  

  void fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // First try to get name and email from local storage
      final storedFullName = LocalStorage.myName;
      final storedEmail = LocalStorage.myEmail;
      final storedProfileImage = LocalStorage.myProfileImage;

      // Set the values from local storage first for immediate UI update
      fullName.value = storedFullName;
      email.value = storedEmail;
      profileImageUrl.value = storedProfileImage;

      if (storedEmail.isEmpty) {
        AppLogger.error("=====================>>>   No stored email found", error: "User not logged in or email not found");
        throw Exception("User not logged in or email not found");
      }

      // Fetch fresh data from the server
      final response = await _profileService.getProfileData(email: storedEmail);

      if (response['success'] == true) {
        final profileData = response['data'] ?? {};

        // Update with fresh data from server
        fullName.value =
            profileData['full_name']?.toString() ??
            profileData['name']?.toString() ??
            storedFullName;

        email.value = profileData['email']?.toString() ?? storedEmail;
        // Try to map possible image keys (backend dependent)
        final apiImageRaw = (profileData['image'] ?? profileData['profileImage'] ?? profileData['avatar'] ?? '').toString();
        if (apiImageRaw.isNotEmpty) {
          // Build absolute URL if backend returns relative path
          final normalized = apiImageRaw.startsWith('http')
              ? apiImageRaw
              : '${AppUrls.imageUrl}$apiImageRaw';
          profileImageUrl.value = normalized;
          await LocalStorage.setString(LocalStorageKeys.myProfileImage, profileImageUrl.value);
        }

        // Update local storage with fresh data
        if (fullName.value.isNotEmpty) {
          await LocalStorage.setString(LocalStorageKeys.myName, fullName.value);
        }
        if (email.value.isNotEmpty) {
          await LocalStorage.setString(LocalStorageKeys.myEmail, email.value);
        }
        if (phone.value.isNotEmpty) {
          await LocalStorage.setString(LocalStorageKeys.phone, phone.value);
        }
        if (address.value.isNotEmpty) {
          await LocalStorage.setString(
            LocalStorageKeys.myAddress,
            address.value,
          );
        }
      } else {
        final errorMsg = response['message'] ?? 'Failed to fetch profile data';
        errorMessage.value = errorMsg;
      }
    } catch (e) {
      final errorMsg = 'Error fetching profile: $e';
      errorMessage.value = errorMsg;
    } finally {
      isLoading.value = false;
    }
  }

}