
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';


Widget buildProfileCard({
  String? name,
  required VoidCallback onTrackPressed,
  required VoidCallback onAutographPressed,
  required VoidCallback onUploadBookPressed,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.sp),
      color: buttonColor,
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.sp),
              child: Image.asset(
                "assets/png/profile.png",
                height: 17.w,
                width: 17.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(
                        color: whiteColor,
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        text: "Welcome, Reader",
                      ),
                      Icon(Icons.menu, color: Colors.white, size: 20),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(
                        color: whiteColor,
                        fontFamily: 'Poppins',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        text: name ?? "User",
                      ),
                      GestureDetector(
                        onTap: onTrackPressed,
                        child: buttonWidget(
                          "Track Request",
                          buttonColor,
                          colors: bottomNavColor,
                          fontFamily: 'Poppins',
                          height: 3.3.h,
                          width: 22.w,
                          fontsize: 13.sp,
                          fontweight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onAutographPressed,
                child: buttonWidget(
                  "Request Autograph",
                  buttonColor,
                  colors: bottomNavColor,
                  fontFamily: 'Poppins',
                  height: 4.4.h,
                  width: 20.w,
                  fontsize: 15.sp,
                  fontweight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: GestureDetector(
                onTap: onUploadBookPressed,
                child: buttonWidget(
                  "Upload Book",
                  buttonColor,
                  colors: white,
                  fontFamily: 'Poppins',
                  height: 4.4.h,
                  width: 20.w,
                  fontsize: 15.sp,
                  fontweight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}