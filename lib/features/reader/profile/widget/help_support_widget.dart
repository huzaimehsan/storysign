import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';


Widget faqItemWidget({
  required String title,
  required String description,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 0.5.h),
        customText(
          text: title,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: bottomNavColor,
          letterSpacing: 0,
          textAlign: TextAlign.start,
          fontFamily: "Poppins",
        ),
        SizedBox(height: 0.4.h),
        customText(
          text: description,
          fontSize: 14.2.sp,
          letterSpacing: 0,
          fontWeight: FontWeight.w400,
          color: textFeildContainColor,
          textAlign: TextAlign.start,
          fontFamily: "Poppins",
        ),
        SizedBox(height: 0.4.h),

        Divider(
          color: whiteColor.withOpacity(0.5),
          thickness: 1,
        ),
        SizedBox(height: 0.3.h),
      ],
    ),
  );
}