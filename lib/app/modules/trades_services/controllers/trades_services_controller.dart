import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/trade_service/trade_service.dart';
import '../models/sort_filter_options.dart';

class TradesServicesController extends GetxController {
  RxList<Business> businesses = <Business>[].obs;
  RxList<Business> filteredBusinesses = <Business>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  
  // Sorting and filtering
  Rx<SortOption> currentSort = SortOption.nameAsc.obs;
  Rx<FilterOption> currentFilter = FilterOption.all.obs;
  RxBool showFilterDialog = false.obs;
  RxBool showSortDialog = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVerifiedBusinesses();
  }

  Future<void> fetchVerifiedBusinesses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await TradeService.getAllVerifiedBusinesses();
      
      if (response.success) {
        businesses.value = response.data;
        applySortAndFilter();
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Error loading businesses: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshBusinesses() {
    fetchVerifiedBusinesses();
  }

  // Apply both sorting and filtering
  void applySortAndFilter() {
    List<Business> result = List.from(businesses);
    
    // Apply filter
    result = applyFilter(result, currentFilter.value);
    
    // Apply sort
    result = applySort(result, currentSort.value);
    
    filteredBusinesses.value = result;
  }

  // Apply filter
  List<Business> applyFilter(List<Business> businessList, FilterOption filter) {
    switch (filter) {
      case FilterOption.verified:
        return businessList.where((b) => b.isVerified).toList();
      case FilterOption.unverified:
        return businessList.where((b) => !b.isVerified).toList();
      case FilterOption.all:
      default:
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
    showFilterDialog.value = false;
  }

  // Update sort
  void updateSort(SortOption sort) {
    currentSort.value = sort;
    applySortAndFilter();
    showSortDialog.value = false;
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
}
