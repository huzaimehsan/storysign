import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';

class CoverImageWidget extends StatelessWidget {
  final String assetPath;
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const CoverImageWidget({
    super.key,
    required this.assetPath,
    this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final String path = imageUrl?.trim().isNotEmpty == true ? imageUrl!.trim() : assetPath.trim();
    final uri = Uri.tryParse(path);
    final isNetwork = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    final String resolvedPath = isNetwork && uri.host == 'localhost' && Platform.isAndroid
        ? path.replaceFirst('localhost', '10.0.2.2')
        : path;

    Widget placeholder() {
      return Container(
        height: height ?? 12.h,
        width: width ?? 25.w,
        color: Colors.grey.withOpacity(0.2),
        child: Center(
          child: Icon(
            Icons.book_rounded,
            color: buttonColor.withOpacity(0.6),
            size: (width ?? 25.w) * 0.6,
          ),
        ),
      );
    }

    if (path.isEmpty || path == 'null') {
      return placeholder();
    } else if (isNetwork) {
      return Image.network(
        resolvedPath,
        height: height ?? 12.h,
        width: width ?? 25.w,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          final fallbackUri = Uri.tryParse(assetPath);
          final fallbackIsNetwork = fallbackUri != null && (fallbackUri.scheme == 'http' || fallbackUri.scheme == 'https');
          if (assetPath.trim().isEmpty || assetPath == 'null' || fallbackIsNetwork || assetPath.startsWith('/')) {
            return placeholder();
          }
          return Image.asset(
            assetPath,
            height: height ?? 12.h,
            width: width ?? 25.w,
            fit: fit,
            errorBuilder: (context, err, stack) => placeholder(),
          );
        },
      );
    } else if (path.startsWith('/')) {
      return Image.file(
        File(path),
        height: height ?? 12.h,
        width: width ?? 25.w,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder(),
      );
    } else {
      return Image.asset(
        path,
        height: height ?? 12.h,
        width: width ?? 25.w,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder(),
      );
    }
  }
}
