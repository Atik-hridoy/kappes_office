import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import '../../../model/store.dart';

class StoreService {
  final Dio _dio = Dio();
  final String _baseUrl = AppUrls.baseUrl;

  Future<Shop?> fetchStoreDetails(String storeId) async {
    try {
      final endpoint = AppUrls.getShop.replaceFirst('685806ee0d8150920d3662a5', storeId);
      final url = '$_baseUrl$endpoint';
      print('[StoreService] Fetching store details from: $url');
      final response = await _dio.get(url);
      print('[StoreService] Response status: ${response.statusCode}');
      print('[StoreService] Response data: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        return Shop.fromJson(response.data);
      } else {
        print('[StoreService] Failed to load store. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[StoreService] Error fetching store details: $e');
      return null;
    }
  }
}