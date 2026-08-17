import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

Widget settingsOptionTile({
  required image,
  required String title,
  required VoidCallback onTap,
  Color? iconColor,
  EdgeInsetsGeometry? margin,
  bool destructive = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 5.h,
            width: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14.sp),
            ),
            child: Image.asset(
              image!,
              height: 16.w,
              width: 16.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: customText(
              fontFamily: 'Poppins',
              text: title,
              color: destructive ? Colors.red : Colors.black87,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.black38),
        ],
      ),
    ),
  );
}
