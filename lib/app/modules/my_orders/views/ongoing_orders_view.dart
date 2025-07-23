import 'package:canuck_mall/app/modules/my_orders/controllers/my_orders_controller.dart';
import 'package:canuck_mall/app/modules/my_orders/widget/custom_product_order_card.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingOrdersView extends GetView<MyOrdersController> {
  const OngoingOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state (initial load only)
      if (controller.isOngoingLoading && !controller.isOngoingRefreshing) {
        return const Center(child: CircularProgressIndicator());
      }
      // Error state
      else if (controller.ongoingErrorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'Failed to load orders.\n${controller.ongoingErrorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed:
                      () => controller.fetchOngoingOrders(isRefresh: true),
                  icon: const Icon(Icons.replay),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Empty state
      else if (controller.ongoingOrdersList.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_rounded, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No ongoing orders at the moment.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Text(
                'Check back later!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      // Display data
      else {
        final orders = controller.ongoingOrdersList;
        return RefreshIndicator(
          onRefresh: () => controller.fetchOngoingOrders(isRefresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isOngoingLoadingMore &&
                  controller.ongoingHasMoreData &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent) {
                controller.loadMoreOngoingOrders();
              }
              return false;
            },
            child: ListView.separated(
              padding: EdgeInsets.all(AppSize.height(height: 1.5)),
              itemCount:
                  orders.length + (controller.isOngoingLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < orders.length) {
                  final order = orders[index];
                  return CustomProductOrderCard(order: order);
                } else {
                  // Loading more indicator
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: AppSize.height(height: 2.0));
              },
            ),
          ),
        );
      }
    });
  }
}
