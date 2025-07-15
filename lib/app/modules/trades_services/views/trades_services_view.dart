import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/dev_data/trades_dev_data.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/trades_services/widgets/search_box2.dart';
import 'package:canuck_mall/app/modules/trades_services/widgets/trades_card.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/trades_services_controller.dart';

class TradesServicesView extends GetView<TradesServicesController> {
  const TradesServicesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.tradesAndServices,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSize.height(height: 1.2),
                    ),
                    child: AppImage(
                      imagePath: AppImages.tradesAndServices,
                      height: AppSize.height(height: 23.0),
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: AppSize.height(height: 3.5),
                    left: 0.0,
                    right: 0.0,
                    child: Column(
                      children: [
                        AppText(
                          title: AppStaticKey.findTrusted,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(
                            fontSize: AppSize.height(height: 2.0),
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                        AppText(
                          title: AppStaticKey.tradesServicesNearYou,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(
                            fontSize: AppSize.height(height: 2.0),
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: AppSize.height(height: 12.5),
                    right: AppSize.width(width: 6.0),
                    left: AppSize.width(width: 6.0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.searchServicesView);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: IgnorePointer(ignoring: true, child: SearchBox2()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 0.5)),

              // Filter and sort row
              Row(
                children: [
                  // Filter icon
                  ImageIcon(
                    AssetImage(AppIcons.filter2),
                    size: AppSize.height(height: 2.0),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0)),
                  AppText(
                    title: AppStaticKey.filter,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Spacer(),

                  // Sort icon
                  ImageIcon(
                    AssetImage(AppIcons.sort),
                    size: AppSize.height(height: 2.0),
                  ),
                  SizedBox(width: AppSize.width(width: 2.0)),
                  AppText(
                    title: AppStaticKey.sort,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              Divider(color: AppColors.lightGray),
              SizedBox(height: AppSize.height(height: 1.0)),

              /// trades and services
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tradesList.length,
                itemBuilder: (context, index) {
                  return TradesCard(
                    onPressed: (){
                      Get.toNamed(Routes.companyDetails);
                    },
                    image: tradesList[index].image,
                    name: tradesList[index].name,
                    service: tradesList[index].service,
                    address: tradesList[index].address,
                    phone: tradesList[index].phone,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: AppSize.height(height: 1.5));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

