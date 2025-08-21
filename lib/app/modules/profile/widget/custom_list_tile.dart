import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onPressed;

  const CustomListTile({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.height(height: 0.6)),
      child: Material(
        elevation: 1.5,
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(width: 2.0),
                vertical: AppSize.height(height: 1.5),
              ),
              child: Row(
                children: [
                  AppImage(
                    imagePath: image,
                    height: AppSize.height(height: 5.0),
                    width: AppSize.height(height: 5.0),
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: AppColors.error);
                    },
                  ),
                  SizedBox(width: AppSize.width(width: 2.0)),
                  Expanded(
                    child: AppText(
                      title: title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppSize.height(height: 1.80),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: AppSize.height(height: 2.0),
                    color: AppColors.gray,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
