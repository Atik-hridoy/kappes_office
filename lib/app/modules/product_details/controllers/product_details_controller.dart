import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  RxBool isFavourite = false.obs;
  RxString selectColor = "white".obs;
  RxString selectedProductSize = "S".obs;
}
