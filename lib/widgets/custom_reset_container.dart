import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import '../constants/color_constants.dart' as Colors;
import 'button_widget.dart';
import 'customText_widget.dart';

class AuthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String Decs;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final List<Widget> children;

  const AuthCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    required this.children,
    required this.Decs,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 90.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.5.h),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: customText(
                color: white,
                fontFamily: 'Poppins',
                fontSize: 19.sp,
                fontWeight: FontWeight.w600,
                text: title,
                height: 1.0,                 // Line height 100%
                letterSpacing: 0.0,
              ),
            ),
            SizedBox(height: 2.h),
            Center(
              child: customText(
                color: white,
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                text: subtitle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 3.h),

            ...children.map(
              (child) => Column(
                children: [
                  child,
                  SizedBox(height: 2.h),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            buttonWidget(
              buttonText,
              white,
              onTap: onButtonPressed,
              colors: buttonColor,
              fontFamily: 'Poppins',
              height: 5.5.h,
              width: double.infinity,
              fontsize: 16.sp,
              fontweight: FontWeight.w600,
            ),
            SizedBox(height: 2.h),

            customText(
              textAlign: TextAlign.center,
              color: lightTextColor,
              fontFamily: 'Inter',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              text:
                  "We will send a 6-digit verification code to you registered email address ",
            ),
          ],
        ),
      ),
    );
  }
}
