import 'package:canuck_mall/app/model/get_review_model.dart';
import 'package:get/get.dart';
import '../../../data/netwok/product_details/reviews_service.dart';

class ReviewsController extends GetxController {
  // ... existing fields and methods ...

  /// Returns a map of star rating (1-5) to the number of reviews for that rating.
  Map<int, int> get ratingCount {
    final count = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviewsList) {
      final rounded = r.rating.round().clamp(1, 5);
      count[rounded] = count[rounded]! + 1;
    }
    return count;
  }

  /// Returns the percentage (0.0-1.0) of reviews with the given star rating.
  double getPercent(int star) {
    final total = reviewsList.length;
    if (total == 0) return 0;
    return ratingCount[star]! / total;
  }

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
