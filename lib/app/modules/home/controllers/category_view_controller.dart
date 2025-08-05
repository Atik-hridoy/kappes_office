import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:get/get.dart';
import '../../../data/netwok/home/category_service.dart';
import '../../../model/get_populer_category_model.dart';
import '../../../data/local/storage_service.dart';
import 'package:dio/dio.dart';

class CategoryViewController extends GetxController {
  final CategoryService _categoryService = CategoryService();

  final Rx<CategoryResponse?> categoryResponse = Rx<CategoryResponse?>(null);
  final RxList<Category> categories = <Category>[].obs;
  final RxList<String> thumbnails = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // For posting a category (example)
  final Rxn<Category> postedCategory = Rxn<Category>();
  final RxBool isPosting = false.obs;
  final RxString postError = ''.obs;

  String get authToken => LocalStorage.token;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    print('=====================================>>> FETCH CATEGORIES START');
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print(
        '=====================================>>> Loading local storage data',
      );
      await LocalStorage.getAllPrefData(); // Ensure token is loaded
      print(
        '=====================================>>> Token loaded: '
        '\n${authToken.isNotEmpty ? 'Token present' : 'Token missing'}',
      );
      print(
        '=====================================>>> Sending GET request for categories with auth',
      );
      final response = await _categoryService.fetchCategoriesWithAuth(
        authToken,
      ); // uses AppUrls.categories
      print('=====================================>>> Response received!');
      categoryResponse.value = response;
      categories.assignAll(response.data.categories);
      thumbnails.assignAll(
        response.data.categories.map((cat) => cat.thumbnail),
      );
      print(
        '=====================================>>> Categories loaded: ${categories.length}',
      );
      print(
        '=====================================>>> Thumbnails loaded: ${thumbnails.length}',
      );
    } catch (e) {
      print('=====================================>>> ERROR: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      print('=====================================>>> FETCH CATEGORIES END');
    }
  }

  Future<void> postCategory({
    required String name,
    required String description,
  }) async {
    isPosting.value = true;
    postError.value = '';
    try {
      await LocalStorage.getAllPrefData();
      final dio = Dio();
      final response = await dio.get(
        // Adjust endpoint as needed
        '${AppUrls.baseUrl}${AppUrls.categories}',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
      // Parse posted category if needed
      if (response.data != null && response.data['data'] != null) {
        postedCategory.value = Category.fromJson(response.data['data']);
      }
    } catch (e) {
      postError.value = e.toString();
    } finally {
      isPosting.value = false;
    }
  }

  // Utility to get thumbnails
  List<String> getCategoryThumbnails() {
    return categories.map((cat) => cat.thumbnail).toList();
  }
}
