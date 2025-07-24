import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/my_orders/views/completed_orders_view.dart';
import 'package:canuck_mall/app/modules/my_orders/views/ongoing_orders_view.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: AppText(
            title: AppStaticKey.myOrders,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            spacing: AppSize.height(height: 2.0),
            children: [
              Container(
                padding: EdgeInsets.all(AppSize.height(height: 0.7)),
                height: AppSize.height(height: 7.0),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.2),
                  ),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: ShapeDecoration(
                    color: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 1.0),
                      ),
                    ),
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.white,
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(text: AppStaticKey.ongoing),
                    Tab(text: AppStaticKey.completed),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [OngoingOrdersView(), CompletedOrdersView()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
