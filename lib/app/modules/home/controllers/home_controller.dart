import 'package:get/get.dart';

import '../../../data/netwok/home/home_view_service.dart';
import '../../../model/item_model.dart';
 // Import Item model

class HomeController extends GetxController {
  var isLoading = true.obs;
  var recommendedItems = <Item>[].obs;

  // Instance of the service
  final HomeViewService _homeViewService = HomeViewService();

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedProducts(); // Fetch products when the controller is initialized
  }

  // Function to fetch recommended products
  void fetchRecommendedProducts() async {
    try {
      isLoading(true); // Set loading state to true
      final items = await _homeViewService.fetchRecommendedProducts(); // Fetch products from the service
      recommendedItems.assignAll(items); // Assign the fetched products to the observable list
      print('✅ Recommended Items fetched successfully!'); // Debugging print
    } catch (e) {
      print('❌ Error fetching recommended items: $e'); // Debugging print
    } finally {
      isLoading(false); // Set loading state to false
    }
  }
}
