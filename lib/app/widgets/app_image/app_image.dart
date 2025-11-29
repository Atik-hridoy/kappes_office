import 'dart:io';
import 'package:flutter/material.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';

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
    required this.errorBuilder,
  });

  final Widget Function(BuildContext context, Object error, StackTrace? stackTrace) errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath.toString().isEmpty) {
      return _buildFallbackIcon();
    }

    String path = imagePath.toString();

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

    // Normalize relative API paths to absolute URLs
    path = _normalizeUrl(path);

    // Handle network images
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
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

  String _normalizeUrl(String p) {
    if (p.isEmpty) return p;
    // Already absolute
    if (p.startsWith('http://') || p.startsWith('https://')) return p;
    // If path starts with '/', append to image base
    if (p.startsWith('/')) return '${AppUrls.imageUrl}$p';
    // Common API media prefixes without leading slash
    final prefixes = ['image/', 'images/', 'logo/', 'coverPhoto/', 'banner/'];
    if (prefixes.any((pre) => p.startsWith(pre))) {
      return '${AppUrls.imageUrl}/$p';
    }
    return p; // treat as asset
  }

  Widget _buildFallbackIcon() {
    final fallbackSize = _resolveFallbackSize();
    final extent = fallbackSize * 1.6;

    final resolvedWidth = (width.isFinite && width > 0) ? width : extent;
    final resolvedHeight = (height.isFinite && height > 0) ? height : extent;

    return SizedBox(
      width: resolvedWidth,
      height: resolvedHeight,
      child: Center(
        child: Icon(
          fallbackIcon,
          size: fallbackSize,
          color: Colors.grey,
        ),
      ),
    );
  }

  double _resolveFallbackSize() {
    final candidates = <double>[];
    if (width.isFinite && width > 0) {
      candidates.add(width);
    }
    if (height.isFinite && height > 0) {
      candidates.add(height);
    }

    final base = candidates.isNotEmpty
        ? candidates.reduce((value, element) => value < element ? value : element)
        : 48.0;

    final clamped = base.clamp(24.0, 128.0).toDouble();
    return clamped * 0.6;
  }
}
