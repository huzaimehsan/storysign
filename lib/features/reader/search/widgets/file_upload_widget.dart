import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:storysign/constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';


class FileUploadWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const FileUploadWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/icon/uploadimg.png",
            fit: BoxFit.cover,
            height: 10.w,
            width: 10.w,
          ),
          SizedBox(height: 1.h),

          // Dynamic Title
          customText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: secondryColor,
            fontFamily: "Poppins",
          ),
          SizedBox(height: 0.5.h),

          // Dynamic Description
          customText(
            text: description,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: textFeildColor,
            fontFamily: "Poppins",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),

          // Custom ButtonWidget with dynamic onTap
          buttonWidget(
            onTap: onTap,
            "Choose File",
            whiteColor,
            fontFamily: 'Poppins',
            colors: buttonColor,
            height: 4.h,
            width: 30.w,
            fontsize: 14.2.sp,
            fontweight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}