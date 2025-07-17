import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ReviewsService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchReviews(String productId) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}/review/product/$productId',
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']['reviews'] ?? [];
      } else {
        throw Exception('Failed to fetch reviews');
      }
    } catch (e) {
      print('🔴 Error fetching reviews: $e');
      rethrow;
    }
  }
}


