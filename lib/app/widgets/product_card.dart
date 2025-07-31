import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/modules/saved/controllers/saved_controller.dart';

class ProductCard extends StatefulWidget {
  final bool? isSaved;
  final String imageUrl;
  final String title;
  final String price;
  final String productId;

  const ProductCard({
    super.key,
    this.isSaved,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.productId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final SavedController savedController = Get.put(SavedController());
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.isSaved ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.productDetails, arguments: widget.productId);
      },
      borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
      child: Container(
        width: AppSize.width(width: 42.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.height(height: 2.0)),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Heart Icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.height(height: 2.0)),
                    topRight: Radius.circular(AppSize.height(height: 2.0)),
                  ),
                  child: SizedBox(
                    height: AppSize.height(height: 15.0),
                    width: double.infinity,
                    child: AppImage(
                      imagePath: widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.height(height: 1.0),
                  right: AppSize.width(width: 1.0),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                      if (isFavourite) {
                        await savedController.saveProduct({
                          'id': widget.productId,
                          'name': widget.title,
                          'imageUrl': widget.imageUrl,
                          'price': widget.price,
                        });
                        Get.snackbar('Saved', 'Product added to wishlist');
                      } else {
                        await savedController.deleteProduct(widget.productId);
                        Get.snackbar(
                          'Removed',
                          'Product removed from wishlist',
                        );
                      }
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
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        size: AppSize.height(height: 2.0),
                        color:
                            isFavourite ? AppColors.lightRed : AppColors.gray,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Title and Price
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(AppSize.height(height: 1.0)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSize.height(height: 0.5)),
                      Text(
                        '\$${widget.price}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
