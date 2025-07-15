import 'package:get/get.dart';
import '../../../data/netwok/store/shop_by_store_service.dart'; // For token retrieval
import '../../../data/local/storage_service.dart';

class ShopByStoreController extends GetxController {
  var shops = <dynamic>[].obs; // Observable list for shops by store name
  final ShopByStoreService _shopByStoreService = ShopByStoreService();

  // Method to fetch shops by store name using the token and searchTerm
  Future<void> fetchShopsByStoreName(String searchTerm) async {
    final token = LocalStorage.token;  // Get the token securely
    if (token.isNotEmpty) {
      final fetched = await _shopByStoreService.getShopsByStoreName(token, searchTerm);
      print('Fetched shops:');
      print(fetched);
      // Print logo and cover for each shop
      for (var i = 0; i < fetched.length; i++) {
        print('Shop #$i logo: ${fetched[i]['logo']}');
        print('Shop #$i coverPhoto: ${fetched[i]['coverPhoto']}');
      }
      shops.value = fetched;
    } else {
      print('No token found. Shops not fetched.');
      shops.value = [];  // Handle case where token is missing
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchShopsByStoreName('');  // Fetch shops initially with an empty searchTerm or pass a valid searchTerm
  }

  // Helpers for StoreCard
  String shopLogo(int index) {
    final url = shops[index]['logo'];
    return (url != null && url.toString().isNotEmpty)
        ? url
        : 'https://via.placeholder.com/80x80.png?text=No+Logo';
  }

  String shopCover(int index) {
    final url = shops[index]['coverPhoto'];
    return (url != null && url.toString().isNotEmpty)
        ? url
        : 'https://via.placeholder.com/300x120.png?text=No+Cover';
  }

  String shopIcon(int index) {
    final url = shops[index]['iconUrl'];
    return (url != null && url.toString().isNotEmpty)
        ? url
        : 'https://via.placeholder.com/40x40.png?text=No+Icon';
  }

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
