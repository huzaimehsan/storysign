import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';

Widget customButton({
  required String text,
  required VoidCallback onTap,
  Color buttonColor = containerColor, // Default Brown color
  Color textColor = whiteColor,
  double? height,
  double? width,
  double? borderRadius,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height ?? 6.h,
      width: width ?? 80.w,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 15.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
