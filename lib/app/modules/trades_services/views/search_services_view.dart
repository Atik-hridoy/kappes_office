import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/trades_services/widgets/trades_card.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../dev_data/trades_dev_data.dart' show tradesList;

class SearchServicesView extends GetView {
  const SearchServicesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.searchService,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.height(height: 2.0),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search box
                SearchBox(title: AppStaticKey.searchService,),
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
              ]),
            ),
          ),

          // Trades cards list
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.height(height: 2.0),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  children: [
                    TradesCard(
                      onPressed: (){
                        Get.toNamed(Routes.companyDetails);
                      },
                      image: tradesList[index].image,
                      name: tradesList[index].name,
                      service: tradesList[index].service,
                      address: tradesList[index].address,
                      phone: tradesList[index].phone,
                    ),
                    // Add separator for all items except the last one
                    index < tradesList.length
                        ? SizedBox(height: AppSize.height(height: 1.5))
                        : SizedBox.shrink(),
                  ],
                );
              }, childCount: tradesList.length),
            ),
          ),

          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: AppSize.height(height: 2.0)),
          ),
        ],
      ),
    );
  }
}
