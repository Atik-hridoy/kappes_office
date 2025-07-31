import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';
import '../../../model/get_populer_category_model.dart';

class CategoryService {
  final Dio _dio = Dio();

  Future<CategoryResponse> fetchCategories() async {
    try {
      final response = await _dio.get(AppUrls.baseUrl + AppUrls.categories);
      print(' Response Status: ${response.statusCode}');
      print(' Response Data: ${response.data}');
      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      print(' Error fetching categories: $e');
      rethrow;
    }
  }

  Future<CategoryResponse> fetchCategoriesWithAuth(String token) async {
    try {
      final response = await _dio.get(
        AppUrls.baseUrl + AppUrls.categories,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(' Response Status: ${response.statusCode}');
      print(' Response Data: ${response.data}');
      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      print(' Error fetching categories (auth): $e');
      rethrow;
    }
  }
}
