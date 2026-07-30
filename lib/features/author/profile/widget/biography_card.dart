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
      fontSize: 14.2.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: textFeildColor,
      fontFamily: 'Poppins',
      height: 1.6,
    ),
  );
}

Widget authorBiographyTextField({
  required TextEditingController controller,
}) {
  return Container(
    width: double.infinity,

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
    child: TextField(
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
        fontSize: 13.6.sp,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: textFeildColor,
        height: 1.6,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(4.w),
        border: InputBorder.none,
        hintText: "Enter biography...",
        hintStyle: TextStyle(color: greyColor),
      ),
    ),
  );
}