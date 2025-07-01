import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/company_details/widget/coupon.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/deals_and_offers_controller.dart';

class DealsAndOffersView extends GetView<DealsAndOffersController> {
  const DealsAndOffersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.dealsOffers,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: ListView.separated(
            itemCount: 4,
            itemBuilder: (context, index){
              return Coupon();
            },
            separatorBuilder:  (context, index){
              return SizedBox(height: AppSize.height(height: 1.5),);
            },
        ),
      ),
    );
  }
}
