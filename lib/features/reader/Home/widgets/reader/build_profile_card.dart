
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';


Widget buildProfileCard({
  required String? name,
  required String? role,
  required String? imagePath,

  required VoidCallback onTrackPressed,
  required VoidCallback onAutographPressed,
  required VoidCallback onUploadBookPressed,
}) {
  Widget _buildProfileImage() {
    final path = imagePath?.trim() ?? '';

    if (path.isEmpty) {
      return Container(
        height: 17.w,
        width: 17.w,
        color: Colors.white12,
        child: Center(
          child: Icon(
            Icons.person,
            size: 10.w,
            color: whiteColor,
          ),
        ),
      );
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        height: 17.w,
        width: 17.w,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: 17.w,
            width: 17.w,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                color: whiteColor,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return  Container(
            height: 17.w,
            width: 17.w,
            color: Colors.white12,
            child: Center(
              child: Icon(
                Icons.person,
                size: 10.w,
                color: whiteColor,
              ),
            ),
          );;
        },
      );
    }

    return Image.asset(
      path,
      height: 17.w,
      width: 17.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/png/profile.png',
          height: 17.w,
          width: 17.w,
          fit: BoxFit.cover,
        );
      },
    );
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.sp),
              child: _buildProfileImage(),
            ),
            SizedBox(width: 3.w),
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
                        // Role parameter ko "Welcome" ke saath combine kar diya
                        text: "Welcome, ${role}",
                      ),

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
                        overFlow: TextOverflow.ellipsis, // Ye text ke aage '...' laga dega
                        maxLines: 1,                    // Text ko ek line se upar nahi jaane dega
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