import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  final bool? isSaved;
  const ProductCard({super.key, this.isSaved});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavourite = false;

  @override
  void initState() {
    if (widget.isSaved != null) {
      if (widget.isSaved!) {
        setState(() {
          isFavourite = widget.isSaved!;
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.productDetails);
      },
      borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
      child: Container(
        width: AppSize.width(width: 42.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.height(height: 2.0)),
                    topRight: Radius.circular(AppSize.height(height: 2.0)),
                  ),
                  child: AppImage(
                    imagePath: AppImages.banner3,
                    height: AppSize.height(height: 19.0),
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: AppSize.height(height: 1.5),
                  right: AppSize.width(width: 2.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSize.height(height: 0.2)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppSize.height(height: 100.0),
                        ),
                      ),
                      child:
                          isFavourite
                              ? Icon(
                                Icons.favorite_outlined,
                                size: AppSize.height(height: 2.3),
                                color: AppColors.lightRed,
                              )
                              : Icon(
                                Icons.favorite_border,
                                size: AppSize.height(height: 2.3),
                              ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppSize.height(height: 1.0)),
              child: Column(
                spacing: AppSize.height(height: 1.0),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title: "Camping Chair - With Multiple Color",
                    maxLine: 5,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  AppText(
                    title: "\$149.99",
                    maxLine: 5,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
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
