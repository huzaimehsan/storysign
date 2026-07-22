import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/color_constants.dart';

Widget buildProfileImageWidget({required String? imagePath}) {
  final path = imagePath?.trim() ?? '';

  if (path.isEmpty) {
    return Container(
      height: 17.w,
      width: 17.w,
      color: Colors.white12,
      child: Center(
        child: Icon(
          Icons.person,
          size: 10.w,
          color: whiteColor,
        ),
      ),
    );
  }

  if (path.startsWith('http://') || path.startsWith('https://')) {
    return Image.network(
      path,
      height: 17.w,
      width: 17.w,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: 17.w,
          width: 17.w,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
              color: whiteColor,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 17.w,
          width: 17.w,
          color: Colors.white12,
          child: Center(
            child: Icon(
              Icons.person,
              size: 10.w,
              color: whiteColor,
            ),
          ),
        );
      },
    );
  }

  return Image.asset(
    path,
    height: 17.w,
    width: 17.w,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        'assets/png/profile.png',
        height: 17.w,
        width: 17.w,
        fit: BoxFit.cover,
      );
    },
  );
}