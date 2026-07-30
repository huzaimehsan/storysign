import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';
import '../../../../widgets/cover_image_widget.dart';

Widget downloadHistoryCard({
  required String imagePath,
  required String title,

  required String date,
  EdgeInsetsGeometry? margin,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 1.h),
    child: Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.all(4.w),

      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: CoverImageWidget(
              assetPath: '',
              imageUrl: imagePath,
              height: 16.w,
              width: 16.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  fontFamily: 'Poppins',
                  text: title,
                  color: secondryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                // SizedBox(height: 0.4.h),
                // customText(
                //   fontFamily: 'Poppins',
                //   text: author,
                //   color: primaryColor,
                //   fontSize: 14.sp,
                //   fontWeight: FontWeight.w500,
                // ),
                SizedBox(height: 0.4.h),
                FormattedRequestDate(
                  dateString:
                      date, // Yeh ab raw date string legi (jaise book.uploadDate.toString())
                  dateFormat: 'dd MMM, yyyy',
                  color: secondryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
