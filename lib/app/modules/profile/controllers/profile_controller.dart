import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/profile/profile_view_get_service.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/modules/profile/bindings/profile_binding.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  var name = ''.obs;
  var email = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;



  void fetchProfile() async {
    try {
      isLoading.value = true; // Set loading to true before fetching
      // Simulate API call or data retrieval
      await Future.delayed(const Duration(seconds: 2)); // Replace with your actual data fetching

      // Example data - replace with actual fetched data
      var fetchedName = "John Doe"; // From your API or storage
      var fetchedEmail = "john.doe@example.com"; // From your API or storage

      if (fetchedName.isNotEmpty && fetchedEmail.isNotEmpty) {
        name.value = fetchedName;
        email.value = fetchedEmail;
      } else {
        // Handle case where data might not be available
        name.value = '-';
        email.value = '-';
        // Optionally show an error message
      }
    } catch (e) {
      print("Error fetching profile: $e");
      // Handle error, maybe show a snackbar or set an error message
      name.value = 'Error';
      email.value = 'Could not load data';
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }
}
