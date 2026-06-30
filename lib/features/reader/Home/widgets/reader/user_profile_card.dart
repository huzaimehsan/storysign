import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';

import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';


Widget userProfileCard({required String imagePath, required String name}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 3.0.h,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                height: 7.h,
                width: 7.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            right: 0.1.h,
            bottom: 0.5.h,
            child: Container(
              height: 1.2.h,
              width: 1.2.h,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 0.5.h),

      SizedBox(
        width: 20.w,

        child: customText(
          color: whiteColor,
          fontFamily: 'Inter',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          text: name.contains(" ") ? name.replaceFirst(" ", "\n") : name,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

Widget sectionHeader({required String title, required VoidCallback onSeeAll}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      customText(
        text: title,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: whiteColor,
      ),
      InkWell(
        onTap: onSeeAll,
        child: customText(
          fontFamily: "Poppins",
          text: "View All >",
          color: iconColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget recentlySignedBooks({
  required String imagePath,
  required String bookTitle,
  required String authorName,
  required String date,
  required VoidCallback trackRequest,
  required String status,
  EdgeInsetsGeometry? margin,
}) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 0.6.h),
    child: Container(
      height: 16.h,
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
              child: Image.asset(
                imagePath,
                height: 12.h,
                width: 25.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    fontFamily: "Poppins",
                    text: bookTitle,
                    color: secondryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 0.6.h),
                  customText(
                    fontFamily: "Poppins",
                    text: authorName,
                    color: primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 0.6.h),
                  customText(
                    fontFamily: "Poppins",
                    text: date,
                    color: secondryColor.withOpacity(0.7),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 0.6.h),
                  buttonWidget(
                    onTap: trackRequest,
                   status ,
                    buttonColor,
                    colors: buttonColor.withOpacity(0.2),
                    fontFamily: 'Poppins',
                    height: 3.h,
                    width: 20.w,
                    borderColor: buttonColor,
                    fontsize: 14.sp,
                    fontweight: FontWeight.w600,
                  ),
                ],
              ),
            ),

            Image.asset(
              "assets/icon/arrowicon.png",
              height: 4.h,
              width: 6.w,
              fit: BoxFit.cover,
            ),
          ],
        ),

    ),
  );
}
