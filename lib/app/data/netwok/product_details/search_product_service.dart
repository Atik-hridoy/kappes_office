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

      final url = '${AppUrls.baseUrl}${AppUrls.searchProduct}';
      print('🔍 Searching URL: $url with params: $requestBody');
      final response = await _dio.get(
        url,
        queryParameters: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('🔍 Response data: $data');
        if (data['success'] == true) {
          final resultData = data['data'];
          List<dynamic> productsData;
          
          // Handle both direct list and paginated result structures
          if (resultData is List) {
            productsData = resultData;
          } else if (resultData is Map && resultData['result'] is List) {
            productsData = resultData['result'];
          } else {
            throw Exception('Invalid response data structure: expected List or Map with "result"');
          }
          
          // Parse the response data into SearchProduct objects
          List<SearchProduct> products = List<SearchProduct>.from(
            productsData.map((x) => SearchProduct.fromJson(x)),
          );
          return products;
        } else {
          throw Exception('API returned success=false: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to fetch search results: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('🔴 Error in service: $e');
      rethrow;
    }
  }
}
