import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/model/create_order_model.dart';

class CheckoutSuccessfulView extends StatelessWidget {
  const CheckoutSuccessfulView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> rawProducts = Get.arguments?['products'] ?? [];
    final List<OrderItem> orderItems =
        rawProducts.isNotEmpty
            ? rawProducts
                .map((item) {
                  if (item is OrderItem) return item;
                  if (item is Map<String, dynamic>)
                    return OrderItem.fromJson(item);
                  return null;
                })
                .whereType<OrderItem>()
                .toList()
            : [];

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.checkout,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: AppSize.height(height: 5.0)),
            Container(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(50),
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 100.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(50),
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 100.0),
                  ),
                ),
                child: ImageIcon(
                  AssetImage(AppIcons.done),
                  color: AppColors.white,
                  size: AppSize.height(height: 5.0),
                ),
              ),
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.thankYouForYourOrder,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: AppSize.height(height: 2.8),
              ),
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title:
                  AppStaticKey
                      .yourOrderIsBeingProcessedAndWillBeShippedShortlyWeAreExcitedToGetYourItemsToYou,
              maxLine: 5,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            // --- Order Items ---
            // if (orderItems.isNotEmpty)
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: orderItems.length,
            //       itemBuilder: (context, index) {
            //         final orderItem = orderItems[index];
            //         return Card(
            //           margin: EdgeInsets.symmetric(vertical: 4),
            //           child: ListTile(
            //             title: Text('Product: ${orderItem.product}'),
            //             subtitle: Text('Quantity: ${orderItem.quantity}'),
            //             trailing: Text('Variant: ${orderItem.variant}'),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // // if (orderItems.isEmpty)
            // //   AppText(
            // //     title: 'No products found in this order.',
            // //     style: Theme.of(context).textTheme.bodyMedium,
            // //   ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppCommonButton(
              onPressed: () {
                Get.toNamed(Routes.myOrders);
              },
              title: AppStaticKey.myOrder,
              fontSize: AppSize.height(height: 2.2),
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppCommonButton(
              onPressed: () {
                Get.until((route) => route.isFirst);
              },
              title: AppStaticKey.home,
              backgroundColor: AppColors.white,
              borderColor: AppColors.lightGray,
              color: AppColors.black,
              fontSize: AppSize.height(height: 2.2),
            ),
          ],
        ),
      ),
    );
  }
}
