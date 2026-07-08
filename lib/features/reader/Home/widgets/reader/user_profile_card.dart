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
            radius: 3.1.h,
            child: ClipOval(


              child: Image.asset(imagePath),

              //
              // Container(
              //   color: Colors.grey.withOpacity(0.2), // Placeholder ka background color
              //   child: Center(
              //     child: Icon(
              //       Icons.person_rounded,
              //       color: buttonColor.withOpacity(0.6),
              //       size: 12.w, // Size adjust karlein
              //     ),
              //   ),
              // ),
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
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
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
        fontSize: 16.sp,
        fontFamily: "Poppins",
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

