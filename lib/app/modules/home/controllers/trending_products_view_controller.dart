import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/home/trending_products_view_service.dart';

class TrendingProductsViewController extends GetxController {
  final TrendingProductsViewService _trendingProductsService = TrendingProductsViewService();
  
  // Reactive state variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final trendingProducts = <dynamic>[].obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final int limit = 10;
  
  // Meta information
  final totalProducts = 0.obs;
  final totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrendingProducts();
  }

  Future<void> fetchTrendingProducts({bool loadMore = false}) async {
    if (isLoading.value) return;
    
    try {
      if (!loadMore) {
        currentPage.value = 1;
        isLoading.value = true;
        errorMessage.value = '';
        print('🔄 Fetching trending products...');
      } else if (!hasMore.value) {
        print('ℹ️ No more products to load');
        return;
      } else {
        currentPage.value++;
        print('🔄 Loading more products, page: ${currentPage.value}');
      }

      final response = await _trendingProductsService.getTrendingProducts(
        page: currentPage.value,
        limit: limit,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        
        if (!loadMore) {
          trendingProducts.clear();
        }
        
        trendingProducts.addAll(data['result'] ?? []);
        
        // Update meta information
        if (data['meta'] != null) {
          totalProducts.value = data['meta']['total'] ?? 0;
          totalPages.value = data['meta']['totalPage'] ?? 1;
          hasMore.value = currentPage.value < totalPages.value;
        }
        
        print('✅ Successfully loaded ${(data['result'] ?? []).length} products');
        print('📊 Total products: ${totalProducts.value}, Has more: ${hasMore.value}');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load products';
        print('❌ Error: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load trending products: $e';
      print('❌ Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    print('🔄 Refreshing products...');
    await fetchTrendingProducts(loadMore: false);
  }

  void loadMoreProducts() {
    if (!isLoading.value && hasMore.value) {
      print('⬇️ Loading more products...');
      fetchTrendingProducts(loadMore: true);
    }
  }
}