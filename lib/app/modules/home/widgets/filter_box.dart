import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

class FilterBox extends StatelessWidget {
  const FilterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.height(height: 1.5)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
      ),
      child: Image.asset(
        AppIcons.filter,
        width: AppSize.height(
          height: 3.0,
        ), // change width to increase/decrease size
        height: AppSize.height(
          height: 3.0,
        ), // change height to increase/decrease size
        fit: BoxFit.contain,
      ),
    );
  }
}
