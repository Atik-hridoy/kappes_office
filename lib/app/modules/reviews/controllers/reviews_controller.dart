import 'package:canuck_mall/app/model/get_review_model.dart';
import 'package:get/get.dart';
import '../../../data/netwok/product_details/reviews_service.dart';

class ReviewsController extends GetxController {
  final ReviewsService _service = ReviewsService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final reviewsData = Rx<GetReviewModel?>(null);
  final reviewsList = <Review>[].obs;

  Future<void> fetchReviews(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      reviewsList.clear();

      print('🟢 Initiating review fetch for product: $productId');

      final result = await _service.fetchReviews(productId);

      reviewsData.value = result;
      reviewsList.assignAll(result.data.result);

      print('🟢 Successfully loaded ${reviewsList.length} reviews');
    } catch (e) {
      errorMessage.value =
          'Error: ${e.toString().replaceAll('Exception: ', '')}';
      print('🔴 Controller error: $e');
      reviewsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  int get totalReviews => reviewsData.value?.data.meta.total ?? 0;

  double get averageRating {
    if (reviewsList.isEmpty) return 0.0;
    final sum = reviewsList.fold(0.0, (prev, review) => prev + review.rating);
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
        await fetchReviews(productId);
        return true;
      }
      errorMessage.value = 'Failed to submit review';
      return false;
    } catch (e) {
      errorMessage.value = 'Submission error: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
