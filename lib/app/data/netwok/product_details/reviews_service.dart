import 'package:canuck_mall/app/model/get_review_model.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ReviewsService {
  final Dio _dio = Dio();

  Future<GetReviewModel> fetchReviews(String productId) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}/review/product/$productId',
      );

      if (response.statusCode == 200) {
        // Parse the response using our model
        return GetReviewModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch reviews: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('🔴 Dio Error fetching reviews: ${e.message}');
      if (e.response != null) {
        print('🔴 Response data: ${e.response?.data}');
        print('🔴 Response status: ${e.response?.statusCode}');
      }
      rethrow;
    } catch (e) {
      print('🔴 Error fetching reviews: $e');
      rethrow;
    }
  }

  // Optional: Add method to post a new review
  Future<bool> postReview({
    required String productId,
    required double rating,
    required String comment,
    List<String>? images,
  }) async {
    try {
      final response = await _dio.post(
        '${AppUrls.baseUrl}/review',
        data: {
          'rating': rating,
          'comment': comment,
          'refferenceId': productId,
          'review_type': 'Product',
          'images': images,
        },
      );

      return response.statusCode == 200 && response.data['success'] == true;
    } on DioException catch (e) {
      print('🔴 Error posting review: ${e.message}');
      return false;
    }
  }
}
