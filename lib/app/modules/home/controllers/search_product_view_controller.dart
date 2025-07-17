import 'package:get/get.dart';
import '../../../data/netwok/product_details/search_product_service.dart';
import '../../../model/search_model.dart';

class SearchProductViewController extends GetxController {
  final SearchProductService _service = SearchProductService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchResults = <SearchProduct>[].obs;

  // Function to search for products based on name, description, and tags
  Future<void> searchProducts({
    String? name,
    String? description,
    List<String>? tags,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('🟢 Search started for: name=[32m$name[0m, description=[32m$description[0m, tags=[32m$tags[0m');

      Map<String, dynamic> requestBody = {};
      // Add all non-null and non-empty fields to requestBody
      if (name != null && name.isNotEmpty) requestBody['name'] = name;
      if (description != null && description.isNotEmpty) requestBody['description'] = description;
      if (tags != null && tags.isNotEmpty) requestBody['tags'] = tags;
      // If nothing is provided, send an empty body to get all results
      if (requestBody.isEmpty) {
        print('🟡 No search parameters provided, fetching all results.');
      }
      print('🟡 Request body: $requestBody');
      final results = await _service.fetchSearchResults(requestBody);
      searchResults.value = results;
      print('🟢 Search results fetched: ${results.length} items');
    } catch (e) {
      errorMessage.value = e.toString();
      print('🔴 Error in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
