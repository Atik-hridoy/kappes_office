import 'package:canuck_mall/app/modules/company_details/controllers/about_us_view_controller.dart';
import 'package:canuck_mall/app/modules/company_details/controllers/contact_us_view_controller.dart';
import 'package:canuck_mall/app/modules/company_details/controllers/services_view_controller.dart';
import 'package:get/get.dart';

import '../controllers/company_details_controller.dart';

class CompanyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyDetailsController>(
      () => CompanyDetailsController(),
    );
    Get.lazyPut<AboutUsViewController>(
      () => AboutUsViewController(),
    );
    Get.lazyPut<ContactUsViewController>(
      () => ContactUsViewController(),
    );
    Get.lazyPut<ServicesViewController>(
      () => ServicesViewController(),
    );
  }
}
