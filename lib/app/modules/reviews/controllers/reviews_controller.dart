import 'package:get/get.dart';
import '../../../data/netwok/product_details/reviews_service.dart';

class ReviewsController extends GetxController {
  final ReviewsService _service = ReviewsService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reviews = <dynamic>[].obs;

  Future<void> fetchReviews(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('🟢 Fetching reviews for product: $productId');
      print('🟡 Product ID: $productId');
      final result = await _service.fetchReviews(productId);
      reviews.value = result;
      print('🟢 Reviews fetched: ${result.length} items');
      print('🟡 Reviews: $result');
    } catch (e) {
      errorMessage.value = e.toString();
      print('🔴 Error in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
