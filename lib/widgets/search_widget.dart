import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';

Widget searchWidget({
  TextEditingController? controller,
  ValueChanged<String>? onChanged,
  String hintText = "Search",
}){

  return   Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w),
    child: Container(
      height: 5.2.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: greyColor),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: blackColor, size: 24),
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.sp,
                  color: textFeildColor,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,

                contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    ),
  );

}