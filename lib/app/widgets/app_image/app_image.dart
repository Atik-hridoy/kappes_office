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
    if (imagePath == null || imagePath.toString().isEmpty) {
      return _buildFallbackIcon();
    }

    final String path = imagePath.toString();

    // Handle File type
    if (imagePath is File) {
      return Image.file(
        imagePath as File,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }

    // Handle network images
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error\nURL: $path');
          return _buildFallbackIcon();
        },
      );
    }

    // Handle asset images
    if (path.isNotEmpty) {
      return Image.asset(
        path,
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
