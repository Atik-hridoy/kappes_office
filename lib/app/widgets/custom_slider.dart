import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSlider extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int length;
  final double? height;
  final List<dynamic>? item;
  const CustomSlider(
      {super.key,
        required this.onChanged,
        required this.length,
        required this.item, this.height,
      });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: List.generate(
            widget.length,
                (index) {
              return InkWell(
                onTap: () {
                  // Get.toNamed(AppRoutes.homeMegaOfferScreen);
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: AppSize.height(height: widget.height ?? 30.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AppImage(
                          imagePath: widget.item![index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      top: AppSize.height(height: 20.0),
                      left: AppSize.width(width: 40.0),
                      child: AnimatedSmoothIndicator(
                        activeIndex: index,
                        count: widget.length,
                        effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.white,
                            dotColor: AppColors.lightGray,
                            dotHeight: AppSize.width(width: 1.5),
                            dotWidth: AppSize.width(width: 1.3),
                            expansionFactor: 4.0),
                      ),
                    )

                  ],
                ),
              );
            },
          ),
          options: CarouselOptions(
            height: AppSize.height(height: 22.0),
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.linear,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, _) {
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}