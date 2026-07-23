import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';

Widget profileHeaderCard({
  required String imagePath,
  required String name,
  required String email,
  required String joinedDate,
  required String plan,
  required String autograph,

  required bool? author,
  VoidCallback? onEdit,
}) {
  ImageProvider? imageProvider;
  final String path = imagePath.trim();
  if (path.isNotEmpty && path != "null") {
    if (path.startsWith('http')) {
      imageProvider = NetworkImage(path);
    } else if (path.startsWith('/') ||
        path.contains(':\\') ||
        path.contains(':/')) {
      imageProvider = FileImage(File(path));
    } else {
      imageProvider = AssetImage(path);
    }
  }

  return Container(
    width: double.infinity,

    padding: EdgeInsets.all(4.5.w),
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 7.5.h,
          width: 7.5.h,
          decoration: BoxDecoration(
            border: Border.all(color: buttonColor, width: 1.2),
            shape: BoxShape.circle,
            color: textFeildContainColor,
            // Background color tab dikhega jab image nahi hogi
            image: imageProvider != null
                ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                : null,
          ),
          // Agar image nahi hai, toh child mein Icon dikhao
          child: imageProvider == null
              ? Icon(
                  Icons.person_rounded,
                  color: buttonColor.withOpacity(0.6),
                  size: 10.w,
                )
              : null,
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
                    color: secondryColor,
                    // Iska color thoda dark rakhein
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700, // Yahan Bold kar diya
                  ),
                  FormattedRequestDate(
                    dateString: joinedDate, // Yeh ab raw date string legi (jaise book.uploadDate.toString())
                    dateFormat: 'dd MMM, yyyy',
                    color:  secondryColor.withOpacity(0.7),
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              SizedBox(height: 1.h),
              Row(
                children: [
                  // Baki widgets...

                  // Agar author true hai, to ye button dikhega
                  if (author == true)
                    buttonWidget(
                      plan,
                      buttonColor,
                      onTap: () {},
                      colors: buttonColor.withOpacity(0.15),
                      fontFamily: 'Poppins',
                      height: 2.6.h,
                      width: 22.w, borderColor: buttonColor,
                      fontsize: 14.sp,
                      fontweight: FontWeight.w600,
                    ),
                  SizedBox(width: 4.w),
                  if (author == true)
                    buttonWidget(
                      "$autograph Autographs",
                      buttonColor,
                      onTap: () {},
                      isShadow: true,
                      colors: bottomNavColor,
                      fontFamily: 'Poppins',
                      height: 2.7.h,
                      width: 30.w,

                      fontsize: 14.sp,
                      fontweight: FontWeight.w500,
                    ),

                  // Agar aapko 'else' mein kuch aur bhi dikhana hai to:
                ],
              ),

              if (author == true) SizedBox(height: 3.h),
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
