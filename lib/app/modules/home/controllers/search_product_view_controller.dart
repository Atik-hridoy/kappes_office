import 'dart:async';
import 'package:get/get.dart';
import '../../../data/netwok/product_details/search_product_service.dart';
import '../../../model/search_model.dart';

class SearchProductViewController extends GetxController {
  final SearchProductService _service = SearchProductService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchResults = <SearchProduct>[].obs;
  
  Timer? _debounce;
  String? categoryId;
  String? categoryName;

  @override
  void onInit() {
    super.onInit();
    // Check if category arguments are passed
    final args = Get.arguments;
    if (args != null && args is Map) {
      categoryId = args['categoryId'];
      categoryName = args['categoryName'];
      // Auto-search products for this category
      if (categoryId != null) {
        searchProductsByCategory(categoryId!);
      }
    } else {
      // Load all products when no category is specified
      fetchAllProducts();
    }
  }

  // Fetch all products
  Future<void> fetchAllProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('🟢 Fetching all products');
      final results = await _service.fetchSearchResults({});
      searchResults.value = results;
      print('🟢 All products fetched: ${results.length} items');
    } catch (e) {
      errorMessage.value = 'Failed to load products: ${e.toString()}';
      print('🔴 Error fetching all products: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Search products by category
  Future<void> searchProductsByCategory(String catId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('🟢 Searching products for category: $catId');
      Map<String, dynamic> requestBody = {'categoryId': catId};
      final results = await _service.fetchSearchResults(requestBody);
      searchResults.value = results;
      print('🟢 Category search results: ${results.length} items');
    } catch (e) {
      errorMessage.value = 'Failed to load category products: ${e.toString()}';
      print('🔴 Error in category search: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Debounced search - waits for user to stop typing before searching
  void searchProducts({
    String? name,
    String? description,
    List<String>? tags,
  }) {
    // Cancel previous timer if user is still typing
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    // If search query is empty, show all products
    if (name == null || name.trim().isEmpty) {
      fetchAllProducts();
      return;
    }
    
    // Show loading immediately
    isLoading.value = true;
    errorMessage.value = '';
    
    // Wait 500ms after user stops typing before making API call
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(name: name, description: description, tags: tags);
    });
  }

  // Actual search function that makes the API call
  Future<void> _performSearch({
    String? name,
    String? description,
    List<String>? tags,
  }) async {
    try {
      print('🟢 Search started for: searchTerm=$name, description=$description, tags=$tags');

      Map<String, dynamic> requestBody = {};
      // Add category filter if present
      if (categoryId != null) requestBody['categoryId'] = categoryId;
      // Add all non-null and non-empty fields to requestBody
      if (name != null && name.isNotEmpty) requestBody['searchTerm'] = name;
      if (description != null && description.isNotEmpty) requestBody['description'] = description;
      if (tags != null && tags.isNotEmpty) requestBody['tags'] = tags;
      
      print('🟡 Request body: $requestBody');
      final results = await _service.fetchSearchResults(requestBody);
      searchResults.value = results;
      print('🟢 Search results fetched: ${results.length} items');
    } catch (e) {
      errorMessage.value = 'Failed to search products: ${e.toString()}';
      print('🔴 Error in controller: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
