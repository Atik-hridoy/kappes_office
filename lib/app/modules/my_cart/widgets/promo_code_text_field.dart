import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:flutter/material.dart';

class PromoCodeTextField extends StatefulWidget {
  final void Function(String code) onApply;
  const PromoCodeTextField({super.key, required this.onApply});

  @override
  State<PromoCodeTextField> createState() => _PromoCodeTextFieldState();
}

class _PromoCodeTextFieldState extends State<PromoCodeTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(width: 2.0),
        vertical: AppSize.width(width: 2.0),
      ),
      height: AppSize.height(height: 6.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
      ),
      child: Row(
        children: [
          ImageIcon(AssetImage(AppIcons.ticket)),
          SizedBox(width: AppSize.width(width: 2.0)),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: AppStaticKey.enterPromoCode,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSize.width(width: 2.0)),
          AppCommonButton(
            onPressed: () {
              widget.onApply(_controller.text.trim());
            },
            height: AppSize.height(height: 4.5),
            width: AppSize.width(width: 22.0),
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(color: AppColors.white),
            borderRadius: BorderRadius.circular(AppSize.height(height: 0.5)),
            title: AppStaticKey.apply,
          ),
        ],
      ),
    );
  }
}
