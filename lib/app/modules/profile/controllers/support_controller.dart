import 'package:get/get.dart';
import 'package:canuck_mall/app/model/contact_model.dart';
import 'package:canuck_mall/app/data/netwok/profile/get_contact_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class SupportController extends GetxController {
  final ContactService _service = ContactService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var contacts = <Contact>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  Future<void> fetchContacts({Map<String, dynamic> query = const {}}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final res = await _service.getContact(query);
      contacts.assignAll(res.data);
      AppLogger.info('✅ Loaded ${contacts.length} contact(s)');
    } catch (e) {
      final msg = 'Failed to load contacts: $e';
      AppLogger.error(msg, tag: 'SupportController', error: msg);
      errorMessage.value = 'Unable to fetch contacts. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}