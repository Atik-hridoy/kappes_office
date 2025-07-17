import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';

class CategoryController extends GetxController {
  var categories = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> fetchCategories() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await Dio().get(AppUrls.baseUrl + AppUrls.category);
      // Correctly parse the nested category list
      categories.value = response.data['data']['categorys'] ?? [];
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
