import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../components/cover_image_widget.dart';
import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';

Widget RequestDetailWidget({
  required String imagePath,
  required String bookTitle,
  String? authorName,
  required String status,
  bool? showSubmittedBadge,
  EdgeInsetsGeometry? margin,
  String? imageUrl,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
    child: Container(
      height: authorName != null ? 13.h : 13.h,
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          // Title and Author Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
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
                if (authorName != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.2.h),
                      customText(
                        fontFamily: "Poppins",
                        text: "Author : $authorName",
                        color: secondryColor.withOpacity(0.7),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      if (showSubmittedBadge == true)
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
              ],
            ),
          ),

          // Submitted Badge
        ],
      ),
    ),
  );
}
