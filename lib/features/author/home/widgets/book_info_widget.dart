import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

Widget bookInfoWidget({
  required String title,
  required String value,
  required Color backgroundColor,
  required Color textColor,
  String? subtitle,
  Color? subtitleColor,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 1.h),
    child: Container(
      width: 26.w,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customText(
            fontFamily: 'Poppins',
            text: title,
            color: textColor.withOpacity(0.85),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 0.8.h),
          customText(
            fontFamily: 'Poppins',
            text: value,
            color: textColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            SizedBox(height: 0.8.h),
            customText(
              fontFamily: 'Poppins',
              text: subtitle,
              color: subtitleColor ?? textColor.withOpacity(0.75),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ],
      ),
    ),
  );
}

Widget libraryStatCardIcon({
  required String title,
  required String value,
  required String subtitle,
  required String imagePath,
  required VoidCallback? ontap,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 1.h),
    child: InkWell(
      onTap: ontap,
      child: Container(
        width: 28.w,
        padding: EdgeInsets.only(right: 1.w, left: 1.w, top: 1.2.h, bottom: 1.2.h),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12.sp),
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customText(
              fontFamily: 'Poppins',
              text: title,
              color: secondryColor.withOpacity(0.70),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            Image.asset(imagePath, height: 7.w, width: 6.w),
          ],
        ),
      ),
    ),
  );
}