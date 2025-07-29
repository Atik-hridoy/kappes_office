import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/my_orders/controllers/my_orders_controller.dart';
import 'package:canuck_mall/app/modules/my_orders/widget/custom_product_order_card.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(
                    AppSize.height(height: 1.0),
                  ),
                ),
                child: const TabBar(
                  tabs: [Tab(text: 'Ongoing'), Tab(text: 'Completed')],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _OrdersTab(isOngoing: true),
                    _OrdersTab(isOngoing: false),
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

// --- OrdersTab widget for tabbed orders ---
class _OrdersTab extends StatelessWidget {
  final bool isOngoing;
  const _OrdersTab({required this.isOngoing});

  @override
  Widget build(BuildContext context) {
    final MyOrdersController controller = Get.find<MyOrdersController>();
    return Obx(() {
      final tabState = controller.getTabState(isOngoing);

      if (tabState.isLoading && tabState.ordersList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (tabState.errorMessage.isNotEmpty && tabState.ordersList.isEmpty) {
        return Center(child: Text('Error: ${tabState.errorMessage}'));
      }
      if (tabState.ordersList.isEmpty) {
        return const Center(child: Text('No orders found.'));
      }
      return RefreshIndicator(
        onRefresh: tabState.refreshOrders,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) => controller.handleScrollNotification(isOngoing, scrollInfo),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: tabState.ordersList.length + (tabState.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < tabState.ordersList.length) {
                // If you want to show real order data, pass order: tabState.ordersList[index] to the card.
                return CustomProductOrderCard(order: tabState.ordersList[index]);
              } else {
                // Loading more indicator
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
            separatorBuilder:
                (context, index) =>
                    SizedBox(height: AppSize.height(height: 2.0)),
          ),
        ),
      );
    });
  }
}
