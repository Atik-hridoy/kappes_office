import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:canuck_mall/app/data/netwok/my_cart_my_order/saved_service.dart';
import 'package:canuck_mall/app/model/wishlist_model.dart';

class SavedController extends GetxController {
  final RxList<SavedModel> wishlist = <SavedModel>[].obs;
  final SavedService _service = SavedService();
  final RxBool isLoading = false.obs;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    _logger.i('Initializing SavedController');
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    _logger.d('Fetching wishlist...');
    try {
      isLoading.value = true;
      final response = await _service.fetchWishlistProducts();

      if (response == null) {
        _logger.w('Received null response when fetching wishlist');
        return;
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        _logger.w('No data field in response');
        return;
      }

      final result = data['result'] as Map<String, dynamic>?;
      if (result == null) {
        _logger.w('No result field in data');
        return;
      }

      final items = result['items'] as List<dynamic>?;
      if (items == null) {
        _logger.w('No items in result');
        return;
      }

      wishlist.clear();
      for (var item in items) {
        try {
          final model = SavedModel.fromJson(item);
          wishlist.add(model);
        } catch (e, stackTrace) {
          _logger.e(
            'Error parsing wishlist item $e',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }

      _logger.i('Successfully loaded ${wishlist.length} items to wishlist');
    } catch (e) {
      _logger.e('Error fetching wishlist', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProduct(String productId) async {
    _logger.d('Saving product to wishlist - Product ID: $productId');
    try {
      final data = await _service.saveProduct(productId);
      if (data != null) {
        await fetchWishlist();
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Error saving product to wishlist - Product ID: $productId',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteProduct(String productId) async {
    _logger.d('Deleting product from wishlist - Product ID: $productId');
    try {
      final data = await _service.deleteProduct(productId);
      if (data != null) {
        _logger.i(
          'Successfully deleted product from wishlist - Product ID: $productId',
        );
        await fetchWishlist();
      } else {
        _logger.w(
          'Received null response when deleting product - Product ID: $productId',
        );
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Error deleting product from wishlist - Product ID: $productId',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  bool isProductSaved(String productId) {
    final isSaved = wishlist.any((item) => item.product.id == productId);
    _logger.v(
      'Checking if product is saved - Product ID: $productId, Is Saved: $isSaved',
    );
    return isSaved;
  }
}
