import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';

import '../../../model/search_model.dart';
import '../../local/storage_keys.dart';

class SearchProductService {
  final Dio _dio = Dio();

  // Fetch Search Results based on dynamic parameters
  Future<List<SearchProduct>> fetchSearchResults(Map<String, dynamic> requestBody) async {
    try {
      final token = await LocalStorage.getString(LocalStorageKeys.token);

      if (token.isEmpty) {
        throw Exception('Token is missing or expired.');
      }

      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.searchProduct}', // Adjust URL if needed
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token for authentication
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          // Parse the response data into SearchProduct objects
          List<SearchProduct> products = List<SearchProduct>.from(
            data['data']['result'].map((x) => SearchProduct.fromJson(x)),
          );
          return products;
        } else {
          throw Exception('Failed to fetch search results');
        }
      } else {
        throw Exception('Failed to fetch search results');
      }
    } catch (e) {
      print('🔴 Error in service: $e');
      rethrow;
    }
  }
}
