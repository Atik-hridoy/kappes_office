import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/login_post_service.dart';

class LoginController extends GetxController {
 RxBool isRemember = false.obs;
 RxBool isPasswordVisible = false.obs;
 RxBool isLoading = false.obs;
 RxString errorMessage = ''.obs;
 RxMap<String, dynamic> user = <String, dynamic>{}.obs;
 RxString token = ''.obs;

 final LoginPostService _loginService = LoginPostService();

 Future<bool> login(String email, String password) async {
  isLoading.value = true;
  errorMessage.value = '';
  final result = await _loginService.login(email: email, password: password);
  isLoading.value = false;
  if (result['success'] == true) {
   user.value = result['user'] ?? {};
   token.value = result['token'] ?? '';
   return true;
  } else {
   errorMessage.value = result['message'] ?? 'Login failed';
   return false;
  }
 }
}
