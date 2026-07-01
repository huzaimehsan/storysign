import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

Widget downloadHistoryCard({
  required String imagePath,
  required String title,
  required String author,
  required String date,
  EdgeInsetsGeometry? margin,
}) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 1.h),
    child: Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.all(4.w),

      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.sp),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: Image.asset(
              imagePath,
              height: 16.w,
              width: 16.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  fontFamily: 'Poppins',
                  text: title,
                  color: secondryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 0.4.h),
                customText(
                  fontFamily: 'Poppins',
                  text: author,
                  color: primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 0.4.h),
                customText(
                  fontFamily: 'Poppins',
                  text: date,
                  color: secondryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
