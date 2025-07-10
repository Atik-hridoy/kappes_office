import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/dev_data/bannar_dev_data.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/widgets/custom_slider.dart';
import 'package:canuck_mall/app/modules/store/widgets/store_header.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/follow_button.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/product_card.dart';
import 'package:canuck_mall/app/widgets/search_box.dart';
import 'package:canuck_mall/app/widgets/tipple.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_readmore/rich_readmore.dart';
import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: SearchBox(
          height: AppSize.height(height: 4.5),
          circularRadius: 1.0,
        ),
        centerTitle: true,
        actions: [
          Tipple(
            onTap: () {
              // AppUtils.appLog("Hello world!");
            },
            height: AppSize.height(height: 5.0),
            width: AppSize.height(height: 5.0),
            borderRadius: BorderRadius.circular(AppSize.height(height: 100.0)),
            positionTop: -8,
            positionRight: -10,
            child: ImageIcon(
              AssetImage(AppIcons.share),
              size: AppSize.height(height: 3.0),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(
          horizontal: AppSize.height(height: 2.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack for the cover image and profile header
            Stack(
              clipBehavior: Clip.none, // Allow content to overflow
              children: [
                // Cover image
                SizedBox(
                  width: double.maxFinite,
                  height: AppSize.height(height: 25.0),
                  child: AppImage(
                    imagePath: AppImages.coverImage,
                    fit: BoxFit.cover,
                  ),
                ),

                // follow button
                Positioned(
                  bottom: AppSize.height(height: 12.0),
                  right: AppSize.width(width: 8.0),
                  child: FollowButton(),
                ),

                // curve background
                Positioned(
                  bottom: 0.0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.maxFinite,
                    height: AppSize.height(height: 10.5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSize.height(height: 3.0)),
                        topRight: Radius.circular(AppSize.height(height: 3.0)),
                      ),
                    ),
                  ),
                ),

                // store header section
                Positioned(
                  bottom: AppSize.height(height: 0.0),
                  left: AppSize.height(height: 3.0),
                  right: 0,
                  child: StoreHeader(
                    onPressed: () {
                      Get.toNamed(Routes.messages);
                    },
                  ),
                ),
              ],
            ),
            
            // Main content below
            Container(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              color: Colors.white,
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// About section
                  AppText(
                    title: AppStaticKey.aboutUs,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
                  ),

                  SizedBox(height: AppSize.height(height: 0.5)),
                  RichReadMoreText.fromString(
                    text: 'StreetStyle Apparel offers stylish, high-quality t-shirts that blend comfort with urban fashion. Perfect for everyday wear, our designs help you express your unique style.',
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
                    settings: LengthModeSettings(
                      trimLength: 120,
                      trimCollapsedText: "..${AppStaticKey.seeMore}",
                      trimExpandedText: AppStaticKey.seeLess,
                      onPressReadMore: () {
                        /// specific method to be called on press to show more
                      },
                      onPressReadLess: () {
                        /// specific method to be called on press to show less
                      },
                      lessStyle: TextStyle(color: AppColors.primary),
                      moreStyle: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 0.5),),
                  Divider(color: AppColors.lightGray,),

                  /// banner
                  SizedBox(height: AppSize.height(height: 1.0),),
                  CustomSlider(
                    onChanged: (value) {},
                    length: bannar.length,
                    item: bannar,
                  ),

                  /// store all products
                  SizedBox(height: AppSize.height(height: 2.0),),
                  Row(
                    children: [
                      /// filter icon
                      ImageIcon(
                        AssetImage(AppIcons.filter2),
                        size: AppSize.height(height: 2.0),
                      ),
                      SizedBox(width: AppSize.width(width: 2.0),),
                      AppText(
                        title: AppStaticKey.filter,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                      ),

                      Spacer(),

                      /// sort icon
                      ImageIcon(
                        AssetImage(AppIcons.sort),
                        size: AppSize.height(height: 2.0),
                      ),
                      SizedBox(width: AppSize.width(width: 2.0),),
                      AppText(
                        title: AppStaticKey.sort,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(height: 1.0),),
                  Divider(color: AppColors.lightGray),
                  SizedBox(height: AppSize.height(height: 1.0),),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: AppSize.height(height: 2.0),
                      crossAxisSpacing: AppSize.height(height: 2.0),
                      childAspectRatio: 0.65, // Adjust to fit your design
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Get.toNamed(AppRoutes.productDetailsScreen);
                        },
                        //child: ProductCard(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
