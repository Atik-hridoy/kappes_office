import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:canuck_mall/app/constants/app_urls.dart';

class RecommendedProductService {
  Future<Map<String, dynamic>> fetchRecommendedProducts() async {
    final url = Uri.parse('${AppUrls.baseUrl}${AppUrls.recommendedProducts}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Failed to fetch recommended products'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
}
