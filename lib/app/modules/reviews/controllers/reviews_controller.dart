import 'package:canuck_mall/app/model/get_review_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../data/netwok/product_details/reviews_service.dart';

class ReviewsController extends GetxController {
  final ReviewsService _service = ReviewsService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reviewsData = Rx<GetReviewModel?>(null);
  var reviewsList = <Review>[].obs; // For easier access to just the reviews

  Future<void> fetchReviews(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🟢 Fetching reviews for product: $productId');

      final result = await _service.fetchReviews(productId);

      reviewsData.value = result;
      reviewsList.value = result.data.result;

      print('🟢 Reviews fetched successfully');
      print('🟡 Total reviews: ${result.data.meta.total}');
      print(
        '🟡 First review: ${reviewsList.firstOrNull?.comment ?? "No reviews"}',
      );
    } on DioException catch (e) {
      errorMessage.value = 'Network error: ${e.message}';
      print('🔴 Dio Error in controller: ${e.message}');
      if (e.response != null) {
        print('🔴 Response data: ${e.response?.data}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load reviews: ${e.toString()}';
      print('🔴 Error in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper getters for easier access to common properties
  int get totalReviews => reviewsData.value?.data.meta.total ?? 0;
  double get averageRating {
    if (reviewsList.isEmpty) return 0.0;
    final sum = reviewsList.map((r) => r.rating).reduce((a, b) => a + b);
    return sum / reviewsList.length;
  }

  Future<bool> submitReview({
    required String productId,
    required double rating,
    required String comment,
    List<String>? images,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _service.postReview(
        productId: productId,
        rating: rating,
        comment: comment,
        images: images,
      );

      if (success) {
        // Refresh reviews after successful submission
        await fetchReviews(productId);
        return true;
      }
      errorMessage.value = 'Failed to submit review';
      return false;
    } catch (e) {
      errorMessage.value = 'Error submitting review: ${e.toString()}';
      print('🔴 Error submitting review: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
