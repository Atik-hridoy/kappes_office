import 'dart:io';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final dynamic imagePath;
  final IconData fallbackIcon;
  final double width;
  final double height;
  final BoxFit fit;

  const AppImage({
    super.key,
    this.imagePath,
    this.fallbackIcon = Icons.image_not_supported,
    this.width = 100.0,
    this.height = 100.0,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return _buildFallbackIcon();
    }

    if (imagePath is File) {
      return Image.file(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }

    if (imagePath is String && imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }

    if (imagePath is String) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }

    // In case the type of imagePath is not supported
    return _buildFallbackIcon();
  }

  Widget _buildFallbackIcon() {
    return Icon(
      fallbackIcon,
      size: width < height ? width * 0.5 : height * 0.5,
      color: Colors.grey,
    );
  }
}
