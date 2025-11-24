import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_details_controller.dart';

class CompanyAboutUsView extends GetView<CompanyDetailsController> {
  const CompanyAboutUsView({super.key});
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
            // Business Description
            if (business.description.isNotEmpty) ...[
              AppText(
                title: business.description,
                maxLine: 1000,
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
            ],
            
            // Business Type
            if (business.type.isNotEmpty) ...[
              AppText(
                title: 'Business Type',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              AppText(
                title: business.type,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
            ],
            
            // Working Hours
            if (business.workingHours.isNotEmpty) ...[
              AppText(
                title: AppStaticKey.businessHour,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: AppSize.height(height: 1.5)),
              ...business.workingHours.map((hour) => Padding(
                padding: EdgeInsets.only(bottom: AppSize.height(height: 0.5)),
                child: Row(
                  children: [
                    AppText(
                      title: '${hour.day}:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: AppSize.width(width: 1.0)),
                    AppText(
                      title: '${hour.start} - ${hour.end}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )).toList(),
              SizedBox(height: AppSize.height(height: 2.0)),
            ],
            
            // Address Details
            AppText(
              title: 'Address',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: AppSize.height(height: 1.5)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (business.address.detailAddress.isNotEmpty) ...[
                  AppText(title: business.address.detailAddress),
                  SizedBox(height: AppSize.height(height: 0.5)),
                ],
                if (business.address.city.isNotEmpty) ...[
                  AppText(title: '${business.address.city}, ${business.address.province}'),
                  SizedBox(height: AppSize.height(height: 0.5)),
                ],
                if (business.address.territory.isNotEmpty) ...[
                  AppText(title: business.address.territory),
                  SizedBox(height: AppSize.height(height: 0.5)),
                ],
                if (business.address.country.isNotEmpty) ...[
                  AppText(title: business.address.country),
                ],
              ],
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            
            // Social Media (placeholder for future implementation)
            AppText(
              title: AppStaticKey.followUsOnSocialMedia,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: AppSize.height(height: 1.5)),
            Row(
              spacing: AppSize.width(width: 2.0),
              children: [
                AppImage(
                  imagePath: AppIcons.facebookIcon,
                  height: AppSize.height(height: 2.5),
                  width: AppSize.height(height: 2.5),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: AppColors.error);
                  },
                ),
                AppImage(
                  imagePath: AppIcons.instagramIcon,
                  height: AppSize.height(height: 2.5),
                  width: AppSize.height(height: 2.5),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: AppColors.error);
                  },
                ),
                AppImage(
                  imagePath: AppIcons.youtubeIcon,
                  height: AppSize.height(height: 2.5),
                  width: AppSize.height(height: 2.5),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: AppColors.error);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
