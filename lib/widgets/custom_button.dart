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
            color: Colors.black.withOpacity(0.1), // Shadow ka rang
            blurRadius: 10,                       // Shadow kitni soft hogi
            spreadRadius: 4,                      // Shadow ko charo taraf kitna failana hai
            offset: Offset(0, 0),                 // Offset 0,0 ka matlab hai "overall"
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