import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
Widget libraryStatCard({
  required String title,
  required String value,
  required String subtitle,
}) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 1.h),
    child: Container(
      width: 28.w,


      padding: EdgeInsets.only(right: 1.w,left: 1.w,top: 1.2.h,bottom: 1.2.h),

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
      // Center alignment ke liye Column ko use karein
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, // Title aur Value bhi center ho jayenge
        children: [
          customText(
            fontFamily: 'Poppins',
            text: title,
            color: secondryColor.withOpacity(0.70),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),

          customText(
            fontFamily: 'Poppins',
            text: value,
            color: secondryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),

          // Subtitle ab center alignment ke sath

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
}) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 1.h),
    child: Container(
      width: 28.w,


      padding: EdgeInsets.only(right: 1.w,left: 1.w,top: 1.2.h,bottom: 1.2.h),

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
      // Center alignment ke liye Column ko use karein
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, // Title aur Value bhi center ho jayenge
        children: [
          customText(
            fontFamily: 'Poppins',
            text: title,
            color: secondryColor.withOpacity(0.70),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),

          Image.asset(imagePath,height: 7.w,width: 6.w,)

          // Subtitle ab center alignment ke sath

        ],
      ),
    ),
  );
}