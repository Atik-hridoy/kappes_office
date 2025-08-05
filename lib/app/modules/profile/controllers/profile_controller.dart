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

  void fetchProfile() async {
    print("=====================>>>   Fetching profile data");
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // First try to get name and email from local storage
      final storedFullName = LocalStorage.myName;
      final storedEmail = LocalStorage.myEmail;

      // Set the values from local storage first for immediate UI update
      fullName.value = storedFullName;
      email.value = storedEmail;

      print("=====================>>>   Stored name: $storedFullName");
      print("=====================>>>   Stored email: $storedEmail");

      if (storedEmail.isEmpty) {
        print("=====================>>>   No stored email found");
        throw Exception("User not logged in or email not found");
      }

      // Fetch fresh data from the server
      final response = await _profileService.getProfileData(email: storedEmail);
      print("=====================>>>   Profile API response: $response");

      if (response['success'] == true) {
        final profileData = response['data'] ?? {};

        // Update with fresh data from server
        fullName.value =
            profileData['full_name']?.toString() ??
            profileData['name']?.toString() ??
            storedFullName;

        email.value = profileData['email']?.toString() ?? storedEmail;

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

        print(
          "=====================>>>   Updated profile data - Name: ${fullName.value}, Email: ${email.value}, Phone: ${phone.value}, Address: ${address.value},",
        );
      } else {
        final errorMsg = response['message'] ?? 'Failed to fetch profile data';
        print("=====================>>>   Profile API error: $errorMsg");
        errorMessage.value = errorMsg;
      }
    } catch (e, stackTrace) {
      final errorMsg = 'Error fetching profile: $e';
      print("=====================>>>   $errorMsg");
      print("=====================>>>   Stack trace: $stackTrace");
      errorMessage.value = errorMsg;
    } finally {
      isLoading.value = false;
      print("=====================>>>   Fetching profile data ended");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }
}