import 'package:flutter/material.dart';

class Tipple extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final Widget child;
  final double? positionTop;
  final double? positionBottom;
  final double? positionLeft;
  final double? positionRight;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color color;
  final Color? splashColor;
  const Tipple({
    super.key,
    required this.child,
    this.positionTop,
    this.positionBottom,
    this.positionLeft,
    this.positionRight,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.borderRadius,
    this.color = Colors.transparent,
    this.height,
    this.width,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: positionTop,
          bottom: positionBottom,
          left: positionLeft,
          right: positionRight,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            onDoubleTap: onDoubleTap,
            borderRadius: borderRadius,
            splashColor: splashColor,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ), // Visible icon
      ],
    );
  }
}

