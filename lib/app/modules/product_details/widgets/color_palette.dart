import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final String value;
  final String group;
  final ValueChanged onChanged;
  final Color? color;
  const ColorPalette({
    super.key,
    required this.value,
    this.color,
    required this.group,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      borderRadius: BorderRadius.circular(AppSize.height(height: 100.0)),
      child: Container(
        height: AppSize.height(height: 5.0),
        width: AppSize.height(height: 5.0),
        decoration: BoxDecoration(
          color: color,
          border:
              value == group
                  ? Border.all(color: AppColors.primary, width: 3.0)
                  : Border.all(color: AppColors.lightGray),
          borderRadius: BorderRadius.circular(AppSize.height(height: 100.0)),
        ),
      ),
    );
  }
}
