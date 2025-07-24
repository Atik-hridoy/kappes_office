import 'package:canuck_mall/app/modules/my_orders/widget/custom_product_order_card.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CompletedOrdersView extends GetView {
  const CompletedOrdersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index) {
          return CustomProductOrderCard();
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: AppSize.height(height: 2.0));
        },
      ),
    );
  }
}
