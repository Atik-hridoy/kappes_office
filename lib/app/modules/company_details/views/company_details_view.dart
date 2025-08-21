import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/company_details/views/company_about_us_view.dart';
import 'package:canuck_mall/app/modules/company_details/views/contact_us_view.dart';
import 'package:canuck_mall/app/modules/company_details/views/services_view.dart';
import 'package:canuck_mall/app/modules/company_details/widget/compnay_details_header.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_details_controller.dart';

class CompanyDetailsView extends GetView<CompanyDetailsController> {
  const CompanyDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: AppColors.white,
          title: AppText(
            title: AppStaticKey.companyDetails,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            // Stack for the cover image and profile header
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none, // Allow content to overflow
                children: [
                  // Cover image
                  SizedBox(
                    width: double.maxFinite,
                    height: AppSize.height(height: 25.0),
                    child: AppImage(
                      imagePath: AppImages.coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: AppColors.error);
                      },
                    ),
                  ),

                  // curve background
                  Positioned(
                    bottom: 0.0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.maxFinite,
                      height: AppSize.height(height: 8.0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSize.height(height: 3.0)),
                          topRight: Radius.circular(
                            AppSize.height(height: 3.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // store header section
                  Positioned(
                    bottom: AppSize.height(height: 0.0),
                    left: AppSize.height(height: 3.0),
                    right: 0,
                    child: CompanyDetailsHeader(),
                  ),
                ],
              ),
            ),

            // Main content below
            SliverFillRemaining(
              hasScrollBody: true,
              child: Container(
                padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                color: Colors.white,
                width: double.maxFinite,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        dividerColor: Colors.transparent,
                        labelPadding: EdgeInsets.zero,
                        tabs: [
                          Tab(text: AppStaticKey.aboutUs),
                          Tab(text: AppStaticKey.services),
                          Tab(text: AppStaticKey.contactUs),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            CompanyAboutUsView(),
                            ServicesView(),
                            ContactUsView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
