import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/profile/profile_view_get_service.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  var name = ''.obs;
  var email = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  



  void fetchProfile() async {
    print("=====================>>>   Fetching profile data");
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final storedEmail = LocalStorage.myEmail;

      if (storedEmail.isEmpty) {
        print("=====================>>>   email is empty data");
        throw Exception("Stored email not found");
      }

      final profileData = await _profileService.getProfileData(email: storedEmail);
      print("=====================>>>   profile data: $profileData");

      name.value = profileData['full_name'] ?? '-';
      email.value = profileData['email'] ?? '-';

      // Optionally store updated profile info
      await LocalStorage.setString(LocalStorageKeys.myName, name.value);
      await LocalStorage.setString(LocalStorageKeys.myEmail, email.value);

    } catch (e) {
      errorMessage.value = e.toString();
      name.value = '';
      email.value = '';
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
    print("=====================>>>   Fetching profile data ended");

  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }


}
