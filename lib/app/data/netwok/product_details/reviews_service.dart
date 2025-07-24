import 'package:canuck_mall/app/model/get_review_model.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

class ReviewsService {
  final Dio _dio = Dio();

  Future<GetReviewModel> fetchReviews(String productId) async {
    try {
      print('🟡 Fetching reviews for product: $productId');
      final response = await _dio.get(
        '${AppUrls.baseUrl}/review/product/$productId',
      );

      print('🟢 Raw response: ${response.data}');

      if (response.statusCode == 200) {
        try {
          final parsedData = GetReviewModel.fromJson(response.data);
          print(
            '🟢 Successfully parsed ${parsedData.data.result.length} reviews',
          );
          return parsedData;
        } catch (e) {
          print('🔴 Parsing error: $e');
          throw Exception('Failed to parse reviews: $e');
        }
      } else {
        throw Exception(
          'Failed to fetch reviews. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('🔴 Dio Error: ${e.message}');
      if (e.response != null) {
        print('🔴 Response data: ${e.response?.data}');
        print('🔴 Status code: ${e.response?.statusCode}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('🔴 Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

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
          'images': images ?? [],
        },
      );
      print('🟢 Response: ${response.data}');

      return response.statusCode == 200 &&
          (response.data['success'] as bool? ?? false);
    } on DioException catch (e) {
      print('🔴 Error posting review: ${e.message}');
      if (e.response != null) {
        print('🔴 Response data: ${e.response?.data}');
      }
      return false;
    }
  }
}
