import 'package:canuck_mall/app/dev_data/company_banner_dev_data.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_details_controller.dart';

class ServicesView extends GetView<CompanyDetailsController> {
  const ServicesView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyDetailsController>();
    
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (controller.errorMessage != null) {
      return Center(
        child: Text(
          controller.errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    
    final business = controller.business;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSize.height(height: 1.5)),
            CustomSlider(
              onChanged: (value) {},
              length: companyBannerList.length,
              item: companyBannerList,
            ),

            /// our services
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.ourServices,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            
            // Display the business service
            if (business.service.isNotEmpty) ...[
              AppText(
                title: '• ${business.service}',
              ),
            ] else ...[
              AppText(
                title: 'No services listed',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
            
            // Additional service information based on business type
            if (business.type.isNotEmpty) ...[
              SizedBox(height: AppSize.height(height: 1.5)),
              AppText(
                title: 'Business Type: ${business.type}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
