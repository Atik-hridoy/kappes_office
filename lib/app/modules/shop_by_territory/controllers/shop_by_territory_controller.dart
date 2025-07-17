import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_urls.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/netwok/store/store_by_territory.dart'; // For token retrieval

class ShopByTerritoryController extends GetxController {
  var shops = <dynamic>[].obs; // Observable list for storing shop data
  final ShopByTerritoryService _shopByTerritoryService = ShopByTerritoryService();
  final String baseUrl = AppUrls.imageUrl;


  // Fetch shops by territory based on the search term
  Future<void> fetchShopsByTerritory(String searchTerm) async {
    final token = LocalStorage.token;  // Use token from LocalStorage
    print('🔑 Using token: $token');  // Debugging: Print token

    if (token.isNotEmpty) {
      List<dynamic> fetchedShops = await _shopByTerritoryService.getShopsByTerritory(token, searchTerm);

      // Debugging: Print fetched data
      print('Fetched shops: $fetchedShops');

      shops.value = fetchedShops;
    } else {
      shops.value = [];  // Handle case where token is missing
      print('🔑 Token is missing');
    }
  }

  // Helpers to get full image URLs for logo and coverPhoto
  String shopLogo(int index) {
    final logo = shops[index]['logo'];
    if (logo != null && logo.toString().isNotEmpty) {
      if (logo.startsWith('http')) return logo;
      return baseUrl + logo;
    }
    return 'https://via.placeholder.com/80x80.png?text=No+Logo';
  }

  String shopCover(int index) {
    final cover = shops[index]['coverPhoto'];
    if (cover != null && cover.toString().isNotEmpty) {
      if (cover.startsWith('http')) return cover;
      return baseUrl + cover;
    }
    return 'https://via.placeholder.com/300x120.png?text=No+Cover';
  }

  @override
  void onInit() {
    super.onInit();
    fetchShopsByTerritory('Toronto');  // Fetch data for Toronto by default or modify as needed
  }
}
