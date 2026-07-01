import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

Widget customNotificationHeader({
  required VoidCallback onBack,
  required VoidCallback onIconPressed,
}) {
  return Container(
    padding: EdgeInsets.only(top: 6.h, left: 5.w, right: 5.w),
    child: Stack(
      alignment: Alignment.center,
      children: [

        customText(
          text: "Notifications",
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: whiteColor,
          textAlign: TextAlign.center,
        ),

        // 2. Row for Back button and Mark All Read
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBack,
              child: Icon(Icons.arrow_back_ios, color: whiteColor, size: 4.w),
            ),
            GestureDetector(
              onTap: onIconPressed,
              child: customText(
                text: "Mark All Read",
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: bottomNavColor,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}Widget notificationTile({
  required String title,
  required String description,
  required String time,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),

        // Title
        customText(
          text: title,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: bottomNavColor,
          textAlign: TextAlign.start,
          maxLines: 1,
          fontFamily: "Poppins",
        ),

        SizedBox(height: 0.3.h),

        // Description
        customText(
          text: description,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: textFeildContainColor,
          letterSpacing: 0,
          textAlign: TextAlign.start,
          fontFamily: "Poppins",
        ),

        SizedBox(height: 0.3.h),

        // Time
        Align(
          alignment: Alignment.centerRight,
          child: customText(
            text: time,
            letterSpacing: 0,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: textFeildContainColor,
            textAlign: TextAlign.center,
            fontFamily: "Poppins",
          ),
        ),



        // Divider
        Divider(
          color: whiteColor.withOpacity(0.5),
          thickness: 1,
        ),

      ],
    ),
  );
}