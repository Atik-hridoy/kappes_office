import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/modules/company_details/widget/coupon.dart';

import '../controllers/deals_and_offers_controller.dart';  // Assuming Coupon is a widget to display each offer
import 'package:flutter/material.dart';






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
        child: Obx(() {
          // If data is being fetched and dealsAndOffers is empty
          if (controller.dealsAndOffers.isEmpty) {
            return Center(child: CircularProgressIndicator()); // Show loading spinner
          }

          return ListView.separated(
            itemCount: controller.dealsAndOffers.length,
            itemBuilder: (context, index) {
              var deal = controller.dealsAndOffers[index];

              // Ensure that data exists for each deal
              return Coupon(
                productName: deal['name'] ?? 'N/A', // Fallback if missing
                basePrice: deal['basePrice'] ?? 0.0, // Fallback if missing
                offerPrice: deal['offerPrice'] ?? 0.0, // Fallback if missing
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: AppSize.height(height: 1.5));
            },
          );
        }),
      ),
    );
  }
}







class Coupon extends StatelessWidget {
  final String productName;
  final double basePrice;
  final double offerPrice;

  const Coupon({
    super.key,
    required this.productName,
    required this.basePrice,
    required this.offerPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Text('Offer Price: \$${offerPrice.toStringAsFixed(2)}'),
        trailing: Text('Base Price: \$${basePrice.toStringAsFixed(2)}'),
      ),
    );
  }
}

