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
    required this.onPressed
  }
  );

  @override
  Widget build(BuildContext context) {
    return  Material(
      elevation: 1.5,
      borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
      child: ListTile(
        onTap: onPressed,
        tileColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
        ),
        leading: AppImage(
          imagePath: image,
          height: AppSize.height(height: 5.0),
          width: AppSize.height(height: 5.0),
        ),
        title: AppText(
          title: title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: AppSize.height(height: 1.80), fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          size: AppSize.height(height: 2.0),
        ),
      ),
    );
  }
}
