// ignore_for_file: library_prefixes

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/netwok/store/shop_by_store_service.dart';
import '../../../data/local/storage_service.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import '../../../model/store/get_all_shops_model.dart';
import '../../../constants/app_urls.dart';
import '../../../utils/image_utils.dart';

class ShopByStoreController extends GetxController {
  static const _pageSize = 10;
  
  final PagingController<int, Shop> pagingController = 
      PagingController(firstPageKey: 1);
  final ShopByStoreService _shopByStoreService = ShopByStoreService();
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchShops(pageKey);
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future<void> fetchShops(int pageKey) async {
    try {
      isLoading.value = true;
      final token = LocalStorage.token;
      
      if (token.isEmpty) {
        AppLogger.error('Authentication token is missing', tag: 'SHOP_BY_STORE', error: 'Please log in to view shops');
        throw Exception('Please log in to view shops');
      }
      
      final shops = await _shopByStoreService.getAllShops(
        token: token,
        page: pageKey,
        limit: _pageSize,
      );
      
      final isLastPage = shops.length < _pageSize;
      
      if (isLastPage) {
        AppLogger.debug('Reached last page of shops', tag: 'SHOP_BY_STORE', error: shops);
        pagingController.appendLastPage(shops);
      } else {
        final nextPageKey = pageKey + 1;
        AppLogger.debug('Loaded ${shops.length} shops, next page: $nextPageKey', tag: 'SHOP_BY_STORE', error: shops);
        pagingController.appendPage(shops, nextPageKey);
      }
    } catch (error) {
      AppLogger.error(
        'Error fetching shops (page $pageKey): $error',
        tag: 'SHOP_BY_STORE',
        error: error.toString(),
      );
      
      pagingController.error = error;
    } finally {
      isLoading.value = false;
    }
  }
  
  void searchShops(String query) {
    searchQuery.value = query;
    pagingController.refresh();
  }
  
  void refreshShops() {
    pagingController.refresh();
  }

  String shopLogo(Shop shop) {
    try {
      final url = _fullUrl(shop.logo ?? shop.banner ?? shop.coverPhoto) ?? '';
      return url.isNotEmpty 
          ? url 
          : ImageUtils.shopLogoPlaceholder;
    } catch (e) {
      AppLogger.error('Error in shopLogo: $e', error: e);
      return ImageUtils.shopLogoPlaceholder;
    }
  }

  String shopCover(Shop shop) {
    try {
      final url = _fullUrl(shop.coverPhoto ?? shop.banner ?? shop.logo) ?? '';
      return url.isNotEmpty 
          ? url 
          : ImageUtils.shopCoverPlaceholder;
    } catch (e) {
      AppLogger.error('Error in shopCover: $e', error: e);
      return ImageUtils.shopCoverPlaceholder;
    }
  }

  String shopIcon(Shop shop) {
    try {
      final url = _fullUrl(shop.logo ?? shop.banner ?? shop.coverPhoto) ?? '';
      return url.isNotEmpty 
          ? url 
          : ImageUtils.shopIconPlaceholder;
    } catch (e) {
      AppLogger.error('Error in shopIcon: $e', error: e);
      return ImageUtils.shopIconPlaceholder;
    }
  }

  String shopName(Shop shop) {
    try {
      return shop.name.isNotEmpty ? shop.name : 'Unnamed Shop';
    } catch (e) {
      AppLogger.error('Error in shopName: $e', error: e);
      return 'Error';
    }
  }

  String address(Shop shop) {
    try {
      final addr = shop.address;
      
      return [
        if (addr.province.isNotEmpty) addr.province,
        if (addr.city.isNotEmpty) addr.city,
        if (addr.country.isNotEmpty) addr.country,
        if (addr.detailAddress.isNotEmpty) addr.detailAddress,
      ].join(', ');
    } catch (e) {
      AppLogger.error('Error in address: $e', error: e);
      return 'Address not available';
    }
  }

  String? _fullUrl(String? path) {
    try {
      if (path == null || path.isEmpty) return null;
      if (path.startsWith('http://') || path.startsWith('https://')) return path;
      if (path.startsWith('/')) return '${AppUrls.imageUrl}$path';
      return '${AppUrls.imageUrl}/$path';
    } catch (e) {
      AppLogger.error('Error in _fullUrl: $e for path: $path', error: e);
      return null;
    }
  }
}
