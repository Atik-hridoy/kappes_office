import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/netwok/store/shop_by_store_service.dart'; // For token retrieval
import '../../../data/local/storage_service.dart';

class ShopByStoreController extends GetxController {
  var shops = <dynamic>[].obs; // Observable list for shops by store name
  final ShopByStoreService _shopByStoreService = ShopByStoreService();

  // Method to fetch shops by store name using the token and searchTerm
  Future<void> fetchShopsByStoreName(String searchTerm) async {
    final token = LocalStorage.token;  // Get the token securely
    if (token.isNotEmpty) {
      shops.value = await _shopByStoreService.getShopsByStoreName(token, searchTerm);
    } else {
      shops.value = [];  // Handle case where token is missing
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Call this method when the view is initialized
    fetchShopsByStoreName('');  // Fetch shops initially with an empty searchTerm or pass a valid searchTerm
  }

  // Helpers for StoreCard
  String shopLogo(int index) => shops[index]['logo'] ?? '';
  String shopCover(int index) => shops[index]['coverPhoto'] ?? '';
  String shopName(int index) => shops[index]['name'] ?? '';
  String address(int index) {
    final addr = shops[index]['address'];
    if (addr is Map) {
      return [
        addr['province'],
        addr['city'],
        addr['country'],
        addr['detail_address']
      ].where((e) => e != null && e.toString().isNotEmpty).join(', ');
    }
    return '';
  }
}
