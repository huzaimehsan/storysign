import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';

import '../../../../widgets/customText_widget.dart';

Widget activeSubscription({
  required String title,
  required String price,
  required String date,
  required String status,
  EdgeInsetsGeometry? margin,
  VoidCallback? ontap,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
    child: Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  fontFamily: 'Poppins',
                  text: title,
                  color: primaryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 0.4.h),
                Row(
                  children: [
                    customText(
                      fontFamily: 'Poppins',
                      text: price,
                      color: secondryColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "  $date ",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: buttonColor,
                            ),
                          ),
                          TextSpan(
                            text: "/m",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: secondryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: ontap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                customText(
                  fontFamily: 'Poppins',
                  text: status,
                  color: buttonColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(width: 1.w),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: buttonColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
