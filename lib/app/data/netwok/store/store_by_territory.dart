import 'package:dio/dio.dart';
import '../../../constants/app_urls.dart';
import '../../../utils/log/app_log.dart';
import '../../../model/store/get_teretory_model.dart';

class ShopByTerritoryService {
  final Dio _dio = Dio();

  // Fetch territories using searchTerm and token
  Future<Territory> getTerritories(String token, String searchTerm) async {
    try {
      final term = (searchTerm).trim();
      final url = term.isEmpty
          ? '${AppUrls.baseUrl}${AppUrls.shopByTerritory}'
          : '${AppUrls.baseUrl}${AppUrls.shopByTerritory}?searchTerm=$term';
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;
      AppLogger.debug('🌐 Territory response: $data', tag: 'SHOP_TERRITORY');
      if (data is Map<String, dynamic>) {
        // Handle multiple possible backend shapes
        final raw = data['data'];
        List<dynamic> list;
        if (raw is List) {
          list = raw;
        } else if (raw is Map && raw['result'] is List) {
          list = raw['result'] as List;
        } else {
          list = const [];
        }

        // Normalize items to TerritoryData using flexible key mapping
        final normalized = list.map<Map<String, dynamic>>((item) {
          if (item is Map) {
            final province = (item['province'] ?? item['territory']) as String?;
            final count = item['productCount'] ?? item['totalProducts'] ?? 0;
            return {
              'province': province,
              'productCount': (count is int) ? count : int.tryParse('$count') ?? 0,
            };
          }
          return {'province': null, 'productCount': 0};
        }).toList();

        final territory = Territory(
          success: data['success'] == true,
          message: data['message']?.toString() ?? '',
          data: normalized.map((e) => TerritoryData.fromJson(e)).toList(),
        );
        AppLogger.info('📦 Parsed territories: ${territory.data.length}', tag: 'SHOP_TERRITORY');
        return territory;
      }
      AppLogger.warning('Unexpected response type for territory', tag: 'SHOP_TERRITORY');
      return Territory(success: false, message: 'Invalid response', data: []);
    } catch (e) {
      AppLogger.error('❌ Error fetching territories: $e', tag: 'SHOP_TERRITORY', error: e.toString());
      return Territory(success: false, message: e.toString(), data: []);
    }
  }
}
