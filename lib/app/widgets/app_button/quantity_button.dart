import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatefulWidget {
  final double? buttonSize;
  final double? buttonCircularSize;
  final double? spacing;
  final double? textSize;
  const QuantityButton({super.key, this.buttonSize, this.spacing, this.textSize,this.buttonCircularSize});

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.height(height: 1.0),
        vertical: AppSize.height(height: 0.5),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSize.width(width: widget.spacing ?? 5.0),
        children: [
          InkWell(
            onTap: (){
             if(quantity > 1){
               setState(() {
                 --quantity;
               });
             }
            },
            borderRadius: BorderRadius.circular(
              AppSize.height(height: 100.0),
            ),
            child: Container(
              height: AppSize.height(height: widget.buttonCircularSize ?? 3.0),
              width:  AppSize.height(height: widget.buttonCircularSize ?? 3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 100.0),
                ),
                border: Border.all(color: AppColors.lightGray),
              ),
              child: Icon(Icons.remove, size: AppSize.height(height: widget.buttonSize ?? 2.5)),
            ),
          ),
          AppText(title: quantity.toString(), style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: widget.textSize)),
          InkWell(
            onTap: (){
              setState(() {
                ++quantity;
              });
            },
            borderRadius: BorderRadius.circular(
              AppSize.height(height: 100.0),
            ),
            child: Container(
              height: AppSize.height(height: widget.buttonCircularSize ?? 3.0),
              width:  AppSize.height(height: widget.buttonCircularSize ?? 3.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(
                  AppSize.height(height: 100.0),
                ),
              ),
              child: Icon(
                Icons.add,
                size: AppSize.height(height: widget.buttonSize ?? 2.5),
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
