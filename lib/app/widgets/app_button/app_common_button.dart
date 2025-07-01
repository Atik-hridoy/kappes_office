import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class AppCommonButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? fontSize;
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? color;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  // New gradient parameters
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;

  const AppCommonButton({
    super.key,
    this.height,
    this.width,
    required this.onPressed,
    required this.title,
    this.backgroundColor,
    this.borderColor,
    this.color,
    this.shape,
    this.style,
    this.gradient,
    this.gradientColors,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight, this.borderRadius, this.padding, this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Create the default gradient if gradientColors are provided
    final Gradient? buttonGradient = gradient ??
        (gradientColors != null
            ? LinearGradient(
          colors: gradientColors!,
          begin: gradientBegin,
          end: gradientEnd,
        )
            : null);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 0.0,
        maxHeight: AppSize.height(height: 7.0),
      ),
      child: SizedBox(
        width: width ?? double.maxFinite,
        height: height ?? AppSize.height(height: 6.5),
        child: buttonGradient != null
            ? _GradientButton(
          onPressed: onPressed,
          padding: padding,
          gradient: buttonGradient,
          borderRadius: borderRadius ?? BorderRadius.circular(10.0),
          shape: shape,
          borderColor: borderColor ?? AppColors.primary,
          child: AppText(
            title: title,
            style: style ??
                Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: color ?? AppColors.white),
          ),
        )
            : ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            elevation: 0.0,
            padding: padding,
            shape: shape ??
                RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(10.0),
                ),
            side: BorderSide(color: borderColor ?? AppColors.primary),
          ),
          child: AppText(
            title: title,
            style: style ??
                Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: color ?? AppColors.white, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}

// Helper widget to create a gradient button
class _GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Gradient gradient;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final OutlinedBorder? shape;
  final Color borderColor;

  const _GradientButton({
    required this.child,
    required this.onPressed,
    required this.gradient,
    this.borderRadius,
    this.shape,
    required this.borderColor, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
              ),
        ),
        child: child,
      ),
    );
  }
}