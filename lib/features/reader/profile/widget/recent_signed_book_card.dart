import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';
Widget recentSignedBookCard({
  required String title,
  required String price,
  required String date,
  required String status,
  EdgeInsetsGeometry? margin,
  VoidCallback? ontap,
}) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 1.h),
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
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start, // Button ko vertically center karne ke liye
        children: [
          customText(
            fontFamily: 'Poppins',
            text: title,
            color: secondryColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 0.8.h),
          Row(
            children: [

              customText(
                fontFamily: 'Poppins',
                text: price,
                color: buttonColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
              // Date ko normal color ka
              customText(
                fontFamily: 'Poppins',
                text: " - ",
                color: secondryColor.withOpacity(0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              FormattedRequestDate(
                dateString: date, // Yeh ab raw date string legi (jaise book.uploadDate.toString())
                dateFormat: 'dd MMM, yyyy',
                color:  secondryColor.withOpacity(0.7),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              buttonWidget(
                status ,
                buttonColor,
                colors: buttonColor.withOpacity(0.2),
                fontFamily: 'Poppins',
                height: 3.h,
                width: 20.w,
                borderColor: buttonColor,
                fontsize: 13.sp,
                fontweight: FontWeight.w600,
              ),

            ],
          ),
        ],
      ),
    ),
  );
}