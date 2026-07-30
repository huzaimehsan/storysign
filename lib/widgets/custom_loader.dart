import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'customText_widget.dart';

Widget customLoader({
  String text = 'Loading...',
  Color textColor = buttonColor,
  Color indicatorColor = buttonColor,
  Color backgroundColor = white,
  double radius = 18,
  double textSize = 12,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 14.sp,
          height: 14.sp,
          child: CircularProgressIndicator(
            color: indicatorColor,
            strokeWidth: 3,
          ),
        ),
        SizedBox(width: 3.w),
        Flexible(
          child: customText(
            text: text,
            fontSize: textSize.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: textColor,
            overFlow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
