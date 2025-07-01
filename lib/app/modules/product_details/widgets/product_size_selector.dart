import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ProductSizeSelector extends StatelessWidget {
  final String value;
  final String group;
  final ValueChanged onChanged;
  const ProductSizeSelector({
    super.key,
    required this.value,
    required this.group,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onChanged(value);
      },
      child: Container(
        height: AppSize.height(height: 5.0),
        width: AppSize.height(height: 7.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: value == group ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppSize.height(height: 0.8)),
          border:
              value == group
                  ? null : Border.all(color: AppColors.lightGray),
        ),
        child: AppText(
          title: value,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: value == group ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
