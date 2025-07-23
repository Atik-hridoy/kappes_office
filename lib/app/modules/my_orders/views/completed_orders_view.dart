import 'package:canuck_mall/app/modules/my_orders/controllers/my_orders_controller.dart';
import 'package:canuck_mall/app/modules/my_orders/widget/custom_product_order_card.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedOrdersView extends GetView<MyOrdersController> {
  const CompletedOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ⏳ Show loading indicator for initial load
      if (controller.isCompletedLoadingMore) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (controller.isCompletedLoading &&
          controller.completedOrdersList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      // ❌ Show error message
      else if (controller.completedErrorMessage.isNotEmpty &&
          controller.completedOrdersList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppSize.width(width: 5.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                SizedBox(height: AppSize.height(height: 2.0)),
                Text(
                  'Failed to load completed orders.\n${controller.completedErrorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                SizedBox(height: AppSize.height(height: 3.0)),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchCompletedOrders(),
                  icon: const Icon(Icons.replay),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(width: 5.0),
                      vertical: AppSize.height(height: 1.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSize.height(height: 0.8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // 📦 Show empty state
      else if (controller.completedOrdersList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Text(
                'No completed orders yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              Text(
                'Your fulfilled orders will appear here.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      // ✅ Display completed orders
      else {
        final orders = controller.completedOrdersList;
        return RefreshIndicator(
          onRefresh: () => controller.fetchCompletedOrders(isRefresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isCompletedLoadingMore &&
                  controller.completedHasMoreData &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                controller.loadMoreCompletedOrders();
              }
              return false;
            },
            child: ListView.separated(
              padding: EdgeInsets.all(AppSize.height(height: 1.5)),
              itemCount: orders.length,
              separatorBuilder:
                  (context, index) =>
                      SizedBox(height: AppSize.height(height: 1.5)),
              itemBuilder: (context, index) {
                return CustomProductOrderCard(order: orders[index]);
              },
            ),
          ),
        );
      }
    });
  }
}
