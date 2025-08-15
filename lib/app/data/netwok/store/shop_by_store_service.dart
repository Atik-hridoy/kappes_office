import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../constants/app_urls.dart';
import '../../../utils/log/app_log.dart';
import '../../../model/store/get_all_shops_model.dart';

class ShopByStoreService {
  final Dio _dio = Dio();

  // Fetch all shops with optional fields selection
  Future<List<Shop>?> getAllShops(
    String token, {
    List<String> fields = const ['name', 'description', 'logo', 'coverPhoto', 'banner', 'address'],
  }) async {
    try {
      final url = '${AppUrls.baseUrl}${AppUrls.getAllShops}';
      final response = await _dio.get(
        url,
        queryParameters: {
          if (fields.isNotEmpty) 'fields': fields.join(','),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );


      print("===========>> Shop By Store statuscode  $response.statusCode");
        List<Shop> shopList = [];



        if(response.statusCode==200){  

          var data =response.data["data"]["result"];

         
          for(var shop in data){
            shopList.add(Shop.fromJson(shop));
          }
        }


        print("===========>> Shop By Store After condition  $shopList");




      return shopList;
    } catch (e) {
      AppLogger.error('❌ Error fetching shops: $e', tag: 'SHOP_BY_STORE', error: e.toString());
     
    }
  }




}
