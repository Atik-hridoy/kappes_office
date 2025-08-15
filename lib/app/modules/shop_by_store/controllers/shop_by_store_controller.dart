// ignore_for_file: library_prefixes

import 'package:get/get.dart';
import '../../../data/netwok/store/shop_by_store_service.dart'; 
import '../../../data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class ShopByStoreController extends GetxController {
  var shops = <dynamic>[].obs; 
  final ShopByStoreService _shopByStoreService = ShopByStoreService();

  Future<void> fetchShopsByStoreName(String searchTerm) async {
    final token = LocalStorage.token;  
    if (token.isNotEmpty) {
      final fetched = await _shopByStoreService.getShopsByStoreName(token, searchTerm);
      AppLogger.info('Fetched shops count: ${fetched.length}');
      for (var i = 0; i < fetched.length; i++) {
        AppLogger.info('Shop #$i logo: ${fetched[i]['logo']}');
        AppLogger.info('Shop #$i coverPhoto: ${fetched[i]['coverPhoto']}');
      }
      shops.value = fetched;
    } else {
      AppLogger.warning('No token found. Shops not fetched.');
      shops.value = []; 
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchShopsByStoreName(''); 
  }

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
