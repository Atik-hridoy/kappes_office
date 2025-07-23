import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/my_orders/views/completed_orders_view.dart';
import 'package:canuck_mall/app/modules/my_orders/views/ongoing_orders_view.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_orders_controller.dart'; // Ensure this import is correct

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 Ensure MyOrdersController is put into GetX's dependency manager.
    // It's often best to put controllers in a Binding for proper lifecycle management.
    // If not using a Binding, calling Get.put() here is acceptable for simple cases.
    Get.put(MyOrdersController());

    return DefaultTabController(
      length: 2, // Must match the number of children in TabBarView
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: AppText(
            title: AppStaticKey.myOrders,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          actions: [
            // Example: A global refresh button managed by MyOrdersController
            Obx(
              () => IconButton(
                icon:
                    controller.isRefreshingAllOrders
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.refresh),
                tooltip: 'Refresh All Orders',
                onPressed:
                    controller.isRefreshingAllOrders
                        ? null // Disable button while refreshing
                        : () {
                          controller.refreshAllOrders(); // Call global refresh
                        },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
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
                  unselectedLabelColor: AppColors.darkGray,
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(text: AppStaticKey.ongoing),
                    Tab(text: AppStaticKey.completed),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Expanded(
                child: TabBarView(
                  children: const [
                    OngoingOrdersView(), // First tab content
                    CompletedOrdersView(), // Second tab content
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
