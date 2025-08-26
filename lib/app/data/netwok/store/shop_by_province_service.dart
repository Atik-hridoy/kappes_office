import 'package:dio/dio.dart';

import '../../../constants/app_urls.dart';
import '../../../utils/log/app_log.dart';
import '../../../model/store/get_province_model.dart';

class ShopByProvinceService {
  final Dio _dio = Dio();

  // Fetch shops by province from the backend
  Future<ProvinceStore> getShopsByProvince(String token) async {
    try {
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getShopsByProvince}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;
      AppLogger.debug('🌐 Province response: $data', tag: 'SHOP_PROVINCE', error: data);
      if (data is Map<String, dynamic>) {
        return ProvinceStore.fromJson(data);
      }
      AppLogger.warning('Unexpected response type for provinces', tag: 'SHOP_PROVINCE');
      return ProvinceStore(success: false, message: 'Invalid response', data: []);
    } catch (e) {
      AppLogger.error(
        '❌ Error fetching shops by province: $e',
        tag: 'SHOP_PROVINCE',
        error: 'Error fetching shops by province: $e',
      );
      return ProvinceStore(success: false, message: e.toString(), data: []);
    }
  }
}
