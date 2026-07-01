import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

Widget profileHeaderCard({
  required String imagePath,
  required String name,
  required String email,
  required String joinedDate,
  VoidCallback? onEdit,
}) {
  return Container(
    width: double.infinity,

    padding: EdgeInsets.all(4.5.w),
    decoration:BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(20.sp),
      boxShadow: [
        BoxShadow(
          color:blackColor.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 7.5.h,
          width: 7.5.h,
          decoration: BoxDecoration(
            border: Border.all(color: buttonColor, width: 1.2),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                fontFamily: 'Poppins',
                text: name,
                color: secondryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 0.4.h),
              customText(
                fontFamily: 'Poppins',
                text: email,
                color: secondryColor.withOpacity(0.75),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 0.4.h),
              Row(
                children: [
                  customText(
                    fontFamily: 'Poppins',
                    text: 'Joined: ',
                    color: secondryColor, // Iska color thoda dark rakhein
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700, // Yahan Bold kar diya
                  ),
                  customText(
                    fontFamily: 'Poppins',
                    text: joinedDate,
                    color: secondryColor.withOpacity(0.7),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400, // Normal weight
                  ),
                ],
              )
            ],
          ),
        ),
        InkWell(
          onTap: onEdit,
          child: Image.asset(
            "assets/png/edit.png",
            height: 4.w,
            width: 4.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}
