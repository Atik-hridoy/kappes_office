// ignore_for_file: library_prefixes


import 'package:get/get.dart';
import '../../../data/netwok/store/shop_by_store_service.dart';
import '../../../data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import '../../../model/store/get_all_shops_model.dart';
import '../../../constants/app_urls.dart';

class ShopByStoreController extends GetxController {

  final shops = <Shop>[].obs;
  final isLoading = false.obs;
  final ShopByStoreService _shopByStoreService = ShopByStoreService();


  Future<void> fetchShopsByStoreName(String searchTerm) async {
    isLoading.value = true;
    final token = LocalStorage.token;
    try {
      isLoading(true);
      if (token.isEmpty) {
        {
          AppLogger.warning('No token found. Shops not fetched.');
        }
        shops.clear();
        return;
      }

      List<Shop> shpList = await _shopByStoreService.getAllShops(token) ?? [];

      AppLogger.debug("============>> get shop by chironjit before ${shpList.length}");

      if (shpList.isNotEmpty) {
        shops.value = shpList;
      }

      isLoading(false);
    } catch (e) {
      AppLogger.error(
        'Shop fetch error: $e',
        tag: 'SHOP_BY_STORE',
        error: e.toString(),
        context: {'error': e.toString()},
      );
      shops.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchShopsByStoreName('');
  }

  String shopLogo(int index) {
    final s = shops[index];
    final url = _fullUrl(s.logo ?? s.banner ?? s.coverPhoto);
    return (url != null && url.toString().isNotEmpty)
        ? url
        : 'https://via.placeholder.com/80x80.png?text=No+Logo';
  }

  String shopCover(int index) {
    final s = shops[index];
    final url = _fullUrl(s.coverPhoto ?? s.banner ?? s.logo);
    return (url != null && url.toString().isNotEmpty)
        ? url
        : 'https://via.placeholder.com/300x120.png?text=No+Cover';
  }

  String shopIcon(int index) {
    // No iconUrl in model; reuse logo as icon fallback
    final s = shops[index];
    final url = _fullUrl(s.logo ?? s.banner ?? s.coverPhoto);
    return (url != null && url.toString().isNotEmpty)
        ? url
        : 'https://via.placeholder.com/40x40.png?text=No+Icon';
  }

  String shopName(int index) => shops[index].name;
  String address(int index) {
    final addr = shops[index].address;
    return [
      addr.province,
      addr.city,
      addr.country,
      addr.detailAddress,
    ].where((e) => e.toString().isNotEmpty).join(', ');
  }

  String? _fullUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('/')) return '${AppUrls.imageUrl}$path';
    return '${AppUrls.imageUrl}/$path';
  }
}
