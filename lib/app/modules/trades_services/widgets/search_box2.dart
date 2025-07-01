import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

class SearchBox2 extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onSearch;
  final String hintText;
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchBox2({
    super.key,
    this.controller,
    this.onSearch,
    this.hintText = AppStaticKey.searchTradesServices,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height(height: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
      ),
      child: Row(
        children: [
          // Text field area
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(width: 4.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.height(height: 1.0)),
                    bottomLeft: Radius.circular(AppSize.height(height: 1.0)),
                  ),
                  borderSide: BorderSide(color: AppColors.primary)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.height(height: 1.0)),
                      bottomLeft: Radius.circular(AppSize.height(height: 1.0)),
                    ),
                    borderSide: BorderSide(color: AppColors.primary)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.height(height: 1.0)),
                      bottomLeft: Radius.circular(AppSize.height(height: 1.0)),
                    ),
                    borderSide: BorderSide(color: AppColors.primary)
                ),
              ),
              onSubmitted: onSearch,
              scrollPadding: EdgeInsets.zero,
            ),
          ),

          // Search button
          Container(
            width: AppSize.width(width: 12.0),
            decoration: BoxDecoration(
              color: AppColors.primary, // Use your app's primary color (red)
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppSize.height(height: 1.0)),
                bottomRight: Radius.circular(AppSize.height(height: 1.0)),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppSize.height(height: 1.0)),
                  bottomRight: Radius.circular(AppSize.height(height: 1.0)),
                ),
                onTap: () {
                  if (controller != null && onSearch != null) {
                    onSearch!(controller!.text);
                  }
                },
                child: Center(
                  child: ImageIcon(
                    AssetImage(AppIcons.search),
                    size: AppSize.height(height: 2.5),
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
