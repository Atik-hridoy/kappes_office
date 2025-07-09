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
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 0,
          maxHeight: double.infinity,
        ),
        child: Container(
          width: AppSize.width(width: 42.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.height(height: 2.0)),
                      topRight: Radius.circular(AppSize.height(height: 2.0)),
                    ),
                    child: SizedBox(
                      height: AppSize.height(height: 19.0),
                      width: double.infinity,
                      child: AppImage(
                        imagePath: AppImages.banner3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSize.height(height: 1.0),
                    right: AppSize.width(width: 1.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(AppSize.height(height: 0.5)),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: AppSize.height(height: 2.0),
                          color: isFavourite ? AppColors.lightRed : AppColors.gray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Product Info Section
              Padding(
                padding: EdgeInsets.all(AppSize.height(height: 1.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      "Camping Chair - With Multiple Color",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppSize.height(height: 0.5)),
                    // Price
                    Text(
                      "\$149.99",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
