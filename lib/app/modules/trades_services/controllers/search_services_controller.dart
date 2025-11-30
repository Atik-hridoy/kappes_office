import 'dart:async';
import 'package:get/get.dart';
import '../../../data/netwok/trade_service/trade_service.dart';
import '../../../utils/log/app_log.dart';
import '../models/sort_filter_options.dart';

class SearchServicesController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchResults = <Business>[].obs;
  var allBusinesses = <Business>[].obs;
  var filteredSearchResults = <Business>[].obs;
  
  Timer? _debounce;

  // Sorting and filtering
  Rx<SortOption> currentSort = SortOption.nameAsc.obs;
  Rx<FilterOption> currentFilter = FilterOption.all.obs;

  @override
  void onInit() {
    super.onInit();
    // Load all businesses initially
    fetchAllBusinesses();
  }

  // Fetch all businesses
  Future<void> fetchAllBusinesses() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      AppLogger.info('🟢 Fetching all businesses', tag: 'SEARCH_SERVICES_CONTROLLER');
      final response = await TradeService.getAllBusinesses();
      if (response.success) {
        allBusinesses.value = response.data;
        searchResults.value = response.data;
        applySortAndFilter();
        AppLogger.info('🟢 All businesses fetched: ${response.data.length} items', tag: 'SEARCH_SERVICES_CONTROLLER');
      } else {
        errorMessage.value = response.message;
        AppLogger.error('🔴 Error fetching all businesses: ${response.message}', tag: 'SEARCH_SERVICES_CONTROLLER', error: response.message);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load businesses: ${e.toString()}';
      AppLogger.error('🔴 Error fetching all businesses: $e', tag: 'SEARCH_SERVICES_CONTROLLER', error: e);
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Debounced search - waits for user to stop typing before searching
  void searchBusinesses(String searchTerm) {
    // Cancel previous timer if user is still typing
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    // If search query is empty, show all businesses
    if (searchTerm.trim().isEmpty) {
      searchResults.value = allBusinesses;
      applySortAndFilter();
      return;
    }
    
    // Show loading immediately
    isLoading.value = true;
    errorMessage.value = '';
    
    // Wait 500ms after user stops typing before making API call
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performBusinessSearch(searchTerm);
    });
  }

  // Actual search function that makes the API call
  Future<void> _performBusinessSearch(String searchTerm) async {
    try {
      AppLogger.info('🟢 Business search started for: searchTerm=$searchTerm', tag: 'SEARCH_SERVICES_CONTROLLER');
      
      final response = await TradeService.searchBusinesses(searchTerm);
      if (response.success) {
        searchResults.value = response.data;
        applySortAndFilter();
        AppLogger.info('🟢 Business search results fetched: ${response.data.length} items', tag: 'SEARCH_SERVICES_CONTROLLER');
      } else {
        errorMessage.value = response.message;
        AppLogger.error('🔴 Error in business search: ${response.message}', tag: 'SEARCH_SERVICES_CONTROLLER', error: response.message);
        searchResults.clear();
      }
    } catch (e) {
      errorMessage.value = 'Failed to search businesses: ${e.toString()}';
      AppLogger.error('🔴 Error in business search controller: $e', tag: 'SEARCH_SERVICES_CONTROLLER', error: e);
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Apply both sorting and filtering
  void applySortAndFilter() {
    List<Business> result = List.from(searchResults);
    
    // Apply filter
    result = applyFilter(result, currentFilter.value);
    
    // Apply sort
    result = applySort(result, currentSort.value);
    
    filteredSearchResults.value = result;
  }

  // Apply filter
  List<Business> applyFilter(List<Business> businessList, FilterOption filter) {
    switch (filter) {
      case FilterOption.verified:
        return businessList.where((b) => b.isVerified).toList();
      case FilterOption.unverified:
        return businessList.where((b) => !b.isVerified).toList();
      case FilterOption.all:
        return businessList;
    }
  }

  // Apply sort
  List<Business> applySort(List<Business> businessList, SortOption sort) {
    List<Business> result = List.from(businessList);
    
    switch (sort) {
      case SortOption.nameAsc:
        result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.nameDesc:
        result.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case SortOption.ratingAsc:
        result.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case SortOption.ratingDesc:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.verifiedFirst:
        result.sort((a, b) {
          if (a.isVerified && !b.isVerified) return -1;
          if (!a.isVerified && b.isVerified) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
    }
    
    return result;
  }

  // Update filter
  void updateFilter(FilterOption filter) {
    currentFilter.value = filter;
    applySortAndFilter();
  }

  // Update sort
  void updateSort(SortOption sort) {
    currentSort.value = sort;
    applySortAndFilter();
  }

  // Get sort option display name
  String getSortDisplayName(SortOption sort) {
    switch (sort) {
      case SortOption.nameAsc:
        return 'Name (A-Z)';
      case SortOption.nameDesc:
        return 'Name (Z-A)';
      case SortOption.ratingAsc:
        return 'Rating (Low to High)';
      case SortOption.ratingDesc:
        return 'Rating (High to Low)';
      case SortOption.verifiedFirst:
        return 'Verified First';
    }
  }

  // Get filter option display name
  String getFilterDisplayName(FilterOption filter) {
    switch (filter) {
      case FilterOption.all:
        return 'All Businesses';
      case FilterOption.verified:
        return 'Verified Only';
      case FilterOption.unverified:
        return 'Unverified Only';
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
