import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String? title;
  final bool? isEnable;
  final bool redOnly;
  final double? height;
  final double? iconSize;
  final double? circularRadius;
  final VoidCallback? onPressed;
  final TextEditingController? controller; // ✅ NEW

  const SearchBox({
    super.key,
    this.isEnable,
    this.redOnly = false,
    this.onPressed,
    this.title,
    this.height,
    this.iconSize,
    this.circularRadius,
    this.controller, // ✅ NEW
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppSize.height(height: 6.0),
      child: TextField(
        controller: controller, // ✅ NEW
        onTap: onPressed,
        readOnly: redOnly,
        enabled: isEnable,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: AppSize.height(height: 2.0)),
          hintText: title ?? AppStaticKey.search,
          hintStyle: TextStyle(
            fontFamily: "Montserrat",
            fontSize: AppSize.height(height: 1.60),
            color: Colors.grey.shade600,
          ),
          suffixIcon: Transform.scale(
            scale: iconSize ?? 0.4,
            child: ImageIcon(AssetImage(AppIcons.search)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(
              AppSize.height(height: circularRadius ?? 1.5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(
              AppSize.height(height: circularRadius ?? 1.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(
              AppSize.height(height: circularRadius ?? 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
