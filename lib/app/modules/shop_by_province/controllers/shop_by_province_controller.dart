import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/netwok/store/shop_by_province_service.dart';

class ShopByProvinceController extends GetxController {
  var shops = <dynamic>[].obs; 
  final ShopByProvinceService _shopByProvinceService = ShopByProvinceService();

  // Fetch shops by province using the token from LocalStorage
  Future<void> fetchShopsByProvince() async {
    final token = LocalStorage.token;
    print('🔑 Using token: $token');
    if (token.isNotEmpty) {
      final response = await _shopByProvinceService.getShopsByProvince(token);
      print('🌐 Raw shops response: $response');
      if (response.isNotEmpty && response['success'] == true && response['data'] is Map && response['data']['result'] is List) {
        shops.value = response['data']['result'];
      } else {
        shops.value = [];
      }
      print('🛍️ Parsed shops list (length: ${shops.length}):');
      for (var shop in shops) {
        print(shop);
      }
    } else {
      print('⚠️ No token found. Returning empty shop list.');
      shops.value = [];  
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchShopsByProvince();  
  }
}
