import 'dart:typed_data';

import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/constants/app_images.dart';
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
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:dio/dio.dart';

String getImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  return '${AppUrls.baseUrl}$path';
}

class DioImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  const DioImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  @override
  State<DioImage> createState() => _DioImageState();
}

class _DioImageState extends State<DioImage> {
  Uint8List? _bytes;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final response = await Dio().get<List<int>>(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      print('[DioImage] Fetching image: ${widget.imageUrl}, Status: ${response.statusCode}');
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _bytes = Uint8List.fromList(response.data!);
          _loading = false;
        });
        print('[DioImage] Image fetched successfully for: ${widget.imageUrl}');
      } else {
        setState(() {
          _error = true;
          _loading = false;
        });
        print('[DioImage] Failed to fetch image for: ${widget.imageUrl}');
      }
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
      print('[DioImage] Error fetching image for: ${widget.imageUrl}, Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return widget.placeholder ?? const SizedBox.shrink();
    }
    if (_error || _bytes == null) {
      return widget.placeholder ?? const Icon(Icons.broken_image);
    }
    return Image.memory(
      _bytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}

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
            onTap: () {},
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        final shop = controller.store.value;
        final shopData = shop?.data;
        if (shopData == null) {
          return const Center(child: Text('No store data found.'));
        }
        // Debug prints for image flow
        print('[StoreView] shopData.logo: ${shopData.logo}');
        print('[StoreView] coverPhoto: ${shopData.coverPhoto}');
        print('[StoreView] building logo imageUrl: ${getImageUrl(shopData.logo)}');
        print('[StoreView] building cover imageUrl: ${getImageUrl(shopData.coverPhoto.isNotEmpty ? shopData.coverPhoto : AppImages.coverImage)}');

        return SingleChildScrollView(
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
                      imagePath: getImageUrl(shopData.coverPhoto.isNotEmpty ? shopData.coverPhoto : AppImages.coverImage),
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Store logo (circular avatar, centered, overlapping cover)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -AppSize.height(height: 7.0),
                    child: Center(
                      child: CircleAvatar(
                        radius: AppSize.height(height: 7.0),
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: AppSize.height(height: 6.5),
                          backgroundColor: Colors.grey[200],
                          child: DioImage(
                            imageUrl: getImageUrl(shopData.logo),
                            width: AppSize.height(height: 13.0),
                            height: AppSize.height(height: 13.0),
                            fit: BoxFit.cover,
                            placeholder: const Icon(Icons.store, size: 40),
                          ),
                        ),
                      ),
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
                      // You can pass shopData here if StoreHeader needs it
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
                    // Show store ID for debugging
                    SizedBox(height: AppSize.height(height: 0.5)),
                    Text('Store ID: ${shopData.shopId}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: AppSize.height(height: 0.5)),
                    RichReadMoreText.fromString(
                      text: shopData.description.isNotEmpty ? shopData.description : 'No description available.',
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
                      settings: LengthModeSettings(
                        trimLength: 120,
                        trimCollapsedText: "..${AppStaticKey.seeMore}",
                        trimExpandedText: AppStaticKey.seeLess,
                        onPressReadMore: () {},
                        onPressReadLess: () {},
                        lessStyle: TextStyle(color: AppColors.primary),
                        moreStyle: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    SizedBox(height: AppSize.height(height: 0.5)),
                    Divider(color: AppColors.lightGray),

                    /// banner
                    SizedBox(height: AppSize.height(height: 1.0)),
                    CustomSlider(
                      onChanged: (value) {},
                      length: 1, // You can update with shopData.banner if you have multiple banners
                      item: [getImageUrl(shopData.banner.isNotEmpty ? shopData.banner : AppImages.coverImage)],
                    ),

                    /// store all products
                    SizedBox(height: AppSize.height(height: 2.0)),
                    Row(
                      children: [
                        /// filter icon
                        ImageIcon(
                          AssetImage(AppIcons.filter2),
                          size: AppSize.height(height: 2.0),
                        ),
                        SizedBox(width: AppSize.width(width: 2.0)),
                        AppText(
                          title: AppStaticKey.filter,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        /// sort icon
                        ImageIcon(
                          AssetImage(AppIcons.sort),
                          size: AppSize.height(height: 2.0),
                        ),
                        SizedBox(width: AppSize.width(width: 2.0)),
                        AppText(
                          title: AppStaticKey.sort,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 1.0)),
                    Divider(color: AppColors.lightGray),
                    SizedBox(height: AppSize.height(height: 1.0)),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        mainAxisSpacing: AppSize.height(height: 2.0),
                        crossAxisSpacing: AppSize.height(height: 2.0),
                        childAspectRatio: 0.65, // Adjust to fit your design
                      ),
                      itemCount: 0, // TODO: Replace with shopData.products.length if available
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // TODO: Navigate to product details with shopData.products[index]
                          },
                          //child: ProductCard(), // TODO: Pass real product data
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}