
// ignore_for_file: library_prefixes

import 'dart:math' as appLog;

import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';
import '../../../model/get_populer_category_model.dart';
 

class CategoryService {
  final Dio _dio = Dio();

  Future<CategoryResponse> fetchCategories() async {
    try {
      final response = await _dio.get(AppUrls.baseUrl + AppUrls.categories);
      appLog.log(' Response Status: ${response.statusCode}' as num);
      appLog.log(' Response Data: ${response.data}' as num);
      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      appLog.log(' Error fetching categories: $e' as num);
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
      appLog.log(' Response Status: ${response.statusCode}' as num);
      appLog.log(' Response Data: ${response.data}' as num);
      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      appLog.log(' Error fetching categories (auth): $e' as num);
      rethrow;
    }
  }
}
