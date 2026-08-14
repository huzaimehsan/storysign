
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'button_widget.dart';
import '../components/cover_image_widget.dart';
import 'customText_widget.dart';

import 'formatted_date_widget.dart';

Widget recentlySignedBooks({
  required String imagePath,
  String? imageUrl,
  required String bookTitle,
  String authorName = '',
  required String date,
  String dateFormat = 'dd MMM, yyyy',
  VoidCallback? trackRequest,
  required String status,
  EdgeInsetsGeometry? margin,
  bool? iconBadge,
  bool showArrow = true,
  bool showPaidLabel = false,
  String? signed,
  bool showAuthor = false,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
    child: Container(
      height: 15.7.h,
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
            child: CoverImageWidget(
              assetPath: imagePath,
              imageUrl: imageUrl,
              height: 12.h,
              width: 25.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: customText(
                    fontFamily: "Poppins",
                    text: bookTitle,
                    color: secondryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
                if (showAuthor && authorName.isNotEmpty) ...[
                  SizedBox(height: 0.6.h),
                  customText(
                    fontFamily: "Poppins",
                    text: "Author : $authorName",
                    color: primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
                SizedBox(height: 0.6.h),

                FormattedRequestDate(
                  dateString: date, // raw date string (e.g. book.uploadDate)
                  dateFormat: dateFormat,
                  color: secondryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 1.h),
                buttonWidget(
                  status,
                  buttonColor,
                  colors: buttonColor.withOpacity(0.2),
                  fontFamily: 'Poppins',
                  height: 3.h,
                 
                  borderColor: buttonColor,
                  fontsize: 14.sp,
                  fontweight: FontWeight.w600,
                ),
              ],
            ),
          ),

          // Trailing area: Paid label > Arrow > kuch nahi
          if (showPaidLabel)
            customText(
              fontFamily: "Poppins",
              text: "Paid",
              color: Colors.green,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            )
          else if (showArrow)
            InkWell(
              onTap: trackRequest,
              child: Image.asset(
                "assets/icon/arrowicon.png",
                height: 4.h,
                width: 6.w,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    ),
  );
}

Widget signedCopyMessageCard({
  String? title, // String? (Nullable)
  required String message,

  EdgeInsetsGeometry? margin,
}) {
  return Padding(
    padding: margin ?? EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.isNotEmpty) ...[
            customText(
              fontFamily: "Poppins",
              text: title,
              color: secondryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 1.2.h),
          ],

          customText(
            fontFamily: "Poppins",
            text: message,
            color: secondryColor.withOpacity(0.75),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),
  );
}
