import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';

class CategoryService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchCategories() async {
    print('📤 Sending GET request to: ' + AppUrls.baseUrl + AppUrls.category);
    try {
      final response = await _dio.get(AppUrls.baseUrl + AppUrls.category);
      print('📥 Response Status: [32m${response.statusCode}[0m');
      print('📥 Response Data: ${response.data}');
      // Adjust parsing as per backend response
      return response.data['data']['categorys'] ?? [];
    } catch (e) {
      print('❌ Error fetching categories: $e');
      rethrow;
    }
  }
}