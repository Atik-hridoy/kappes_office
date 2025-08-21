import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';
import '../../../utils/log/app_log.dart';
import '../../../model/store/get_all_shops_model.dart';

class ShopByStoreService {
  final Dio _dio = Dio();

  // Fetch all shops with optional fields selection
  Future<List<Shop>> getAllShops({
    String? token,
    List<String> fields = const [
      'name',
      'description',
      'logo',
      'coverPhoto',
      'banner',
      'address',
      'rating',
      'totalReviews',
      'type'
    ],
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = '${AppUrls.baseUrl}${AppUrls.getAllShops}';
      
      // Prepare headers
      final headers = {
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Prepare query parameters
      final queryParams = {
        'page': page,
        'limit': limit,
        if (fields.isNotEmpty) 'fields': fields.join(','),
      };

      final response = await _dio.get(
        url,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null &&
            responseData['data'] != null &&
            responseData['data']['result'] != null) {
          final List<dynamic> shopsData = responseData['data']['result'];
          return shopsData.map((shop) => Shop.fromJson(shop)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load shops: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error(
        '❌ Error fetching shops: ${e.message}',
        tag: 'SHOP_BY_STORE',
        error: e.response?.data,
      );
      if (e.response != null) {
        AppLogger.error(
          'Response data: ${e.response?.data}',
          tag: 'SHOP_BY_STORE', error: e.response?.data,
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Unexpected error: $e',
        tag: 'SHOP_BY_STORE',
        error: stackTrace.toString(),
      );
      rethrow;
    }
  }
}
