import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/widgets/build_profile_image.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

Widget buildProfileCard({
  required String? name,
  required String? role,
  required String? imagePath,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        color: buttonColor,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.sp),
                child: buildProfileImageWidget(imagePath: imagePath),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      color: whiteColor,
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      text:
                          "Welcome, ${role != null && role.isNotEmpty ? role.capitalizeFirst : 'User'}",
                    ),
                    SizedBox(height: 0.8.h),
                    customText(
                      color: whiteColor,
                      fontFamily: 'Poppins',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      text: name ?? "User",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
