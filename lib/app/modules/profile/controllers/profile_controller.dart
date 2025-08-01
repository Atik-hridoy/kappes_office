import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/profile/profile_view_get_service.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/data/local/storage_keys.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  var fullName = ''.obs;
  var email = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var profileImageUrl = ''.obs;

  String _normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    // Remove leading slash if present
    final path = url.startsWith('/') ? url.substring(1) : url;
    if (path.startsWith('image/')) {
      return '${AppUrls.imageUrl}/$path';
    }
    return '${AppUrls.baseUrl}/$path';
  }

  void fetchProfile() async {
    AppLogger.info("Fetching profile data");
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // First try to get name and email from local storage
      final storedFullName = LocalStorage.myName;
      final storedEmail = LocalStorage.myEmail;

      // Set the values from local storage first for immediate UI update
      fullName.value = storedFullName;
      email.value = storedEmail;

      AppLogger.info("Stored name: $storedFullName");
      AppLogger.info("Stored email: $storedEmail");

      if (storedEmail.isEmpty) {
        AppLogger.error("No stored email found");
        throw Exception("User not logged in or email not found");
      }

      // Test API server accessibility first
      final isServerAccessible = await _profileService.testApiServer();
      if (!isServerAccessible) {
        AppLogger.warning(
          "=====================>>>   API server not accessible",
        );
        AppLogger.info(
          "=====================>>>   Using cached profile data from local storage",
        );
        // Continue with local storage data only
        return;
      }

      // Fetch fresh data from the server
      final response = await _profileService.getProfileData();
      AppLogger.info("Profile API response: $response");

      if (response['success'] == true) {
        final profileData = response['data'] ?? {};

        // Update with fresh data from server
        fullName.value =
            profileData['full_name']?.toString() ??
            profileData['name']?.toString() ??
            storedFullName;

        email.value = profileData['email']?.toString() ?? storedEmail;

        // Dynamically update profile image URL if present
        final imageUrl = profileData['image']?.toString() ?? '';
        final normalizedUrl = _normalizeImageUrl(imageUrl);
        if (normalizedUrl.isNotEmpty) {
          profileImageUrl.value = normalizedUrl;
          await LocalStorage.setString(
            LocalStorageKeys.myProfileImage,
            normalizedUrl,
          );
        } else {
          // fallback to local storage for immediate UI
          profileImageUrl.value = _normalizeImageUrl(
            LocalStorage.myProfileImage,
          );
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

        AppLogger.info(
          "Updated profile data - Name: ${fullName.value}, Email: ${email.value}, Phone: ${phone.value}, Address: ${address.value}, Image: ${profileImageUrl.value}",
        );
      } else {
        final errorMsg = response['message'] ?? 'Failed to fetch profile data';
        AppLogger.error("Profile API error: $errorMsg");
        errorMessage.value = errorMsg;
      }
    } catch (e, stackTrace) {
      final errorMsg = 'Error fetching profile: $e';
      AppLogger.error(errorMsg);
      AppLogger.error("Stack trace: $stackTrace");

      // Check if it's a network connectivity issue
      if (e.toString().contains('Network error') ||
          e.toString().contains('connection') ||
          e.toString().contains('timeout')) {
        AppLogger.warning(
          "=====================>>>   Network issue detected, using cached data",
        );
        errorMessage.value =
            'Unable to connect to server. Using cached profile data.';
      } else {
        errorMessage.value = errorMsg;
      }
    } finally {
      isLoading.value = false;
      AppLogger.info("Fetching profile data ended");
    }
  }

  /// Pick and upload a new profile image
  Future<void> pickAndUploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      isLoading.value = true;
      final newImageUrl = await _profileService.updateProfileImage(
        pickedFile.path,
      );
      if (newImageUrl != null && newImageUrl.isNotEmpty) {
        profileImageUrl.value = newImageUrl;
        await LocalStorage.setString(
          LocalStorageKeys.myProfileImage,
          newImageUrl,
        );
        // Optionally, fetch the full profile again for consistency
        fetchProfile();
      }
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load image from local storage for immediate UI
    profileImageUrl.value = LocalStorage.myProfileImage;
    fetchProfile();
  }
}
