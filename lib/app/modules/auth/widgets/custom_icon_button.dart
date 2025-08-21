import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final bool isInProgress;
  final VoidCallback onPressed;
  final TextStyle? style;
  final String title;
  final String path;
  const CustomIconButton(
      {super.key,
        required this.path,
        required this.onPressed,
        required this.isInProgress, required this.title, this.style});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: double.maxFinite,
        height: AppSize.height(height: 7.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Visibility(
          visible: !isInProgress,
          replacement: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage(
                imagePath: path,
                height: AppSize.height(height: 3.0),
                width: AppSize.height(height: 3.0),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: AppColors.error);
                },
              ),
              SizedBox(
                width: AppSize.width(width: 3.0),
              ),
              AppText(title: title, style: style,)
            ],
          ),
        ),
      ),
    );
  }
}