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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // More space between sizes
      child: InkWell(
        onTap: () {
          onChanged(value);
        },
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)), // Slightly larger radius
        child: Container(
          height: AppSize.height(height: 6.0), // Maintain the square shape
          width: AppSize.height(height: 6.0),  // Square shape
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: value == group ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
            border: value == group 
                ? null 
                : Border.all(color: AppColors.lightGray, width: 1.5), // Thicker border for non-selected
            boxShadow: [
              if (value == group)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
            ],
          ),
          child: AppText(
            title: value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: value == group ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.height(height: 2.0), // Slightly larger font size
            ),
          ),
        ),
      ),
    );
  }
}
