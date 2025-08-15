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
  var profileImageUrl = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  

  void fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final storedFullName = LocalStorage.myName;
      final storedEmail = LocalStorage.myEmail;
      final storedProfileImage = LocalStorage.myProfileImage;

      fullName.value = storedFullName;
      email.value = storedEmail;
      profileImageUrl.value = storedProfileImage;

      if (storedEmail.isEmpty) {
        AppLogger.error("=====================>>>   No stored email found", error: "User not logged in or email not found");
        throw Exception("User not logged in or email not found");
      }

      final response = await _profileService.getProfileData(email: storedEmail);

      if (response['success'] == true) {
        final profileData = response['data'] ?? {};

        fullName.value =
            profileData['full_name']?.toString() ??
            profileData['name']?.toString() ??
            storedFullName;

        email.value = profileData['email']?.toString() ?? storedEmail;
        final apiImageRaw = (profileData['image'] ?? profileData['profileImage'] ?? profileData['avatar'] ?? '').toString();
        if (apiImageRaw.isNotEmpty) {
          final normalized = apiImageRaw.startsWith('http')
              ? apiImageRaw
              : '${AppUrls.imageUrl}$apiImageRaw';
          profileImageUrl.value = normalized;
          await LocalStorage.setString(LocalStorageKeys.myProfileImage, profileImageUrl.value);
        }

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