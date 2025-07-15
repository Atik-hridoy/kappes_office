import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/netwok/home/deals_offers_service.dart'; // For token retrieval

class DealsAndOffersController extends GetxController {
  var dealsAndOffers = <dynamic>[].obs; // Observable list for deals and offers
  final DealsAndOffersService _dealsAndOffersService = DealsAndOffersService();

  // Method to fetch deals and offers using the token
  Future<void> fetchDealsAndOffers() async {
    final token = LocalStorage.token; // Get the token securely
    print('🔑 Using token: $token');

    if (token.isNotEmpty) {
      final response = await _dealsAndOffersService.getDealsAndOffers(token);
      print('🌐 Raw response: $response');

      if (response.isNotEmpty) {
        // Update the observable list with the fetched data
        dealsAndOffers.value = response;
      } else {
        // Handle empty response (if no offers found)
        dealsAndOffers.value = [];
        print('No deals and offers found');
      }
    } else {
      dealsAndOffers.value = []; // Handle case where token is missing
      print('🔑 Token is missing');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchDealsAndOffers(); // Fetch deals and offers on controller init
  }
}
