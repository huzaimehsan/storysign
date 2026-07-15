import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/customText_widget.dart';

class CustomMessageDisplay extends StatelessWidget {
  final String label;
  final String message;

  const CustomMessageDisplay({
    super.key,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message Title
          customText(
            fontFamily: "Poppins",
            text: label,
            color: whiteColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 1.h),

          // Container for Message
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: textFeildContainColor,
              borderRadius: BorderRadius.circular(20.sp),
              border: Border.all(
                color: borderGreyColor,
                width: 0.15.h,
              ),
            ),
            child: customText(
              fontFamily: "Poppins",
              text: message,
              color:textFeildColor ,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}