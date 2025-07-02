import 'package:canuck_mall/app/data/network/category_service.dart';
import 'package:get/get.dart';


class CategoryController extends GetxController {
  final categories = <dynamic>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final CategoryService _categoryService = CategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _categoryService.fetchPopularCategories();
      categories.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
