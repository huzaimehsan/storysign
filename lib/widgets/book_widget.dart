
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'button_widget.dart';
import 'customText_widget.dart';

Widget recentlySignedBooks({
  required String imagePath,
  required String bookTitle,
  required String authorName,
  required String date,
  required VoidCallback trackRequest,
  required String status,
  EdgeInsetsGeometry? margin,
  bool? iconBadge,
  bool showArrow = true,
}) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 0.6.h),
    child: Container(
      height: 16.h,
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: Image.asset(
              imagePath,
              height: 12.h,
              width: 25.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  fontFamily: "Poppins",
                  text: bookTitle,
                  color: secondryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 0.6.h),
                customText(
                  fontFamily: "Poppins",
                  text: authorName,
                  color: primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 0.6.h),
                customText(
                  fontFamily: "Poppins",
                  text: date,
                  color: secondryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 1.h),
                buttonWidget(
                  onTap: trackRequest,
                  status ,
                  buttonColor,
                  colors: buttonColor.withOpacity(0.2),
                  fontFamily: 'Poppins',
                  height: 3.h,
                  width: 20.w,
                  borderColor: buttonColor,
                  fontsize: 14.sp,
                  fontweight: FontWeight.w600,
                ),
              ],
            ),
          ),
          if (showArrow)
            Image.asset(
              "assets/icon/arrowicon.png",
              height: 4.h,
              width: 6.w,
              fit: BoxFit.cover,
            ),
        ],
      ),

    ),
  );
}

Widget signedCopyMessageCard({
  String title = 'Message',
  required String message,
  EdgeInsetsGeometry? margin,
}) {
  return Padding(
    padding: margin ?? EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.6.h),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            fontFamily: "Poppins",
            text: title,
            color: secondryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 1.2.h),
          customText(
            fontFamily: "Poppins",
            text: message,
            color: secondryColor.withOpacity(0.8),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    ),
  );
}
