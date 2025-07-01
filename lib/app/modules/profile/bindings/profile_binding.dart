import 'package:canuck_mall/app/modules/profile/controllers/Edit_information_view.dart';
import 'package:canuck_mall/app/modules/profile/controllers/change_password_view_controller.dart';
import 'package:canuck_mall/app/modules/profile/controllers/data_privacy_view_controller.dart';
import 'package:canuck_mall/app/modules/profile/controllers/language_view_controller.dart';
import 'package:canuck_mall/app/modules/profile/controllers/terms_condition_view_controller.dart';
import 'package:get/get.dart';

import '../controllers/about_us_view_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<AboutUsViewController>(
      () => AboutUsViewController(),
    );
    Get.lazyPut<ChangePasswordViewController>(
      () => ChangePasswordViewController(),
    );
    Get.lazyPut<DataPrivacyViewController>(
      () => DataPrivacyViewController(),
    );
    Get.lazyPut<EditInformationViewController>(
      () => EditInformationViewController(),
    );
    Get.lazyPut<LanguageViewController>(
      () => LanguageViewController(),
    );
    Get.lazyPut<TermsConditionsViewController>(
      () => TermsConditionsViewController(),
    );
  }
}
