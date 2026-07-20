

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'button_widget.dart';
import 'customText_widget.dart';
void showSuccessDialog(BuildContext context, {String? desc , VoidCallback? ontap ,String? buttonText}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 92.w,

          padding: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 4.4.w,
          ),
          decoration: BoxDecoration(
            color: textFeildContainColor,
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: buttonColor,
                    width: 0.3.w,
                  ),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: buttonColor,
                  size: 8.w,
                ),
              ),
              SizedBox(height: 3.h),

              // Success Message
              customText(
                fontFamily: "Poppins",
                text: desc ?? "Success!", // Default text agar desc null ho
                color: secondryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),

              // Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: buttonWidget(
                  buttonText!,
                  whiteColor,
                  onTap: ontap,
                  colors: buttonColor,
                  fontFamily: 'Poppins',
                  height: 4.h,
                  width: 35.w,
                  fontsize: 15.sp,
                  fontweight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void finalReviewSucess(BuildContext context, {String? desc}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 92.w,
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 4.w,
          ),
          decoration: BoxDecoration(
            color: textFeildContainColor,
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: buttonColor,
                    width: 0.3.w,
                  ),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: buttonColor,
                  size: 8.w,
                ),
              ),
              SizedBox(height: 3.h),

              // Success Message
              customText(
                fontFamily: "Poppins",
                text: desc ?? "Success!", // Default text agar desc null ho
                color: secondryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),

              // Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: buttonWidget(
                  "Okay" ,
                  whiteColor,
                  onTap: () {
                    // Dialog band karne ke liye
                    Get.back();
                    Get.offAllNamed("/authorbottomnav");

                  },
                  colors: buttonColor,
                  fontFamily: 'Poppins',
                  height: 4.h,
                  width: 35.w,
                  fontsize: 15.sp,
                  fontweight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showDeclineDialog(BuildContext context, {String? desc, VoidCallback? ontap, String? buttonText}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 92.w,
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: textFeildContainColor,
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decline Icon - Red/Warning color
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2), // Light Red Background
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: buttonColor, // Solid Red Border
                    width: 0.3.w,
                  ),
                ),
                child: Icon(
                  Icons.cancel, // Cross icon
                  color: buttonColor,
                  size: 8.w,
                ),
              ),
              SizedBox(height: 3.h),

              // Message
              customText(
                fontFamily: "Poppins",
                text: desc ?? "Request Declined",
                color: secondryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),

              // Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: buttonWidget(
                  buttonText ?? "Close",
                  whiteColor,
                  onTap: ontap ?? () => Get.back(),
                  colors: buttonColor, // Red button for decline action
                  fontFamily: 'Poppins',
                  height: 4.h,
                  width: 35.w,
                  fontsize: 15.sp,
                  fontweight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}