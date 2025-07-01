import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({super.key});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollow = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          isFollow = !isFollow;
        });
      },
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(AppSize.height(height: 0.7)),
        decoration: BoxDecoration(
          color: isFollow ? AppColors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(AppSize.height(height: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSize.width(width: 1.0),
          children: [
            ImageIcon(
              AssetImage(AppIcons.follow2),
              color: isFollow ? AppColors.black : AppColors.white,
              size: AppSize.height(height: 2.5),
            ),
            AppText(
              title:  isFollow ? AppStaticKey.following : AppStaticKey.follow,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: isFollow ? AppColors.black : AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
