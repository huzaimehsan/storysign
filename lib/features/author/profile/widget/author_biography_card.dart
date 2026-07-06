import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/customText_widget.dart';

/// Biography card — a cream rounded container with the author's bio text
Widget authorBiographyCard({required String bio}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(4.w),
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(20.sp),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: customText(
      text: bio,
      fontSize: 13.6.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: textFeildColor,
      fontFamily: 'Poppins',
      height: 1.6,
    ),
  );
}
