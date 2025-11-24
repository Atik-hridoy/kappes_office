import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_details_controller.dart';

class ContactUsView extends GetView<CompanyDetailsController> {
  const ContactUsView({super.key});
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
          spacing: AppSize.height(height: 1.0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSize.height(height: 1.5)),
            
            // Phone
            if (business.phone.isNotEmpty) ...[
              Row(
                spacing: AppSize.width(width: 1.0),
                children: [
                  ImageIcon(
                    AssetImage(AppIcons.phone),
                    size: AppSize.height(height: 2.0),
                  ),
                  AppText(
                    title: business.phone,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            
            // Email
            if (business.email.isNotEmpty) ...[
              Row(
                spacing: AppSize.width(width: 1.0),
                children: [
                  Icon(Icons.email_outlined, size: AppSize.height(height: 2.0)),
                  AppText(
                    title: business.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            
            // Address
            Row(
              spacing: AppSize.width(width: 1.0),
              children: [
                ImageIcon(
                  AssetImage(AppIcons.marker),
                  size: AppSize.height(height: 2.0),
                ),
                Expanded(
                  child: AppText(
                    title: business.location,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            
            // Website (placeholder - could be added to Business model later)
            Row(
              spacing: AppSize.width(width: 1.0),
              children: [
                ImageIcon(
                  AssetImage(AppIcons.networkIcon),
                  size: AppSize.height(height: 2.0),
                ),
                AppText(
                  title: "Website not available",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            /// send message
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.sendUseMessage,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                hintText: AppStaticKey.enterYourFullName,
              ),
            ),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: AppStaticKey.enterYourEmail,
              ),
            ),
            TextField(
              controller: controller.messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: AppStaticKey.enterYourMessage,
              ),
            ),
            SizedBox(height: AppSize.height(height: 1.0)),
            Align(
              alignment: Alignment.center,
              child: AppCommonButton(
                onPressed: controller.isSendingMessage ? () {} : () { controller.sendMessage(); },
                width: AppSize.width(width: 24.0),
                height: AppSize.height(height: 5.0),
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(AppSize.height(height: 0.5)),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: AppColors.white),
                title: controller.isSendingMessage ? 'Sending...' : AppStaticKey.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
