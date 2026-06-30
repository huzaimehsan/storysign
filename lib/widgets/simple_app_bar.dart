import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'customText_widget.dart';

Widget simpleAppBar(String title, {bool? isBack = true,double? spacing, bool? isSkip = false}){
  return Padding(
    padding: EdgeInsets.only(top: 6.h, left: 5.w, right: 5.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isBack == false ? SizedBox(width: 12.w,):
        InkWell(
          onTap: (){
            Get.back();
            print("back");
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            height: 5.h,
            width: 12.w,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: blackColor.withValues(alpha: 0.12)
            ),
            child: Image.asset('assets/png/arrow_back.png',color: blackColor),
          ),
        ),
        SizedBox(width: spacing ?? 12.w),
        customText(
            text: title,
            fontSize: 18.sp,
            color: blueAppBarColor,
            fontWeight: FontWeight.w700,
            fontFamily: "bl_melody"
        ),
        Spacer(),
        Column(
          children: [
            InkWell(
              onTap: (){
                Get.offAllNamed("navbar");
              },
              child: customText(
                text: "Skip",
                fontSize: 15.sp,
                color: blackColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
                fontFamily: "inter",
                txtDecoration: TextDecoration.underline,
                decorationColor: darkGreyColor,
              ),
            ),
            SizedBox(height: 0.5.h,)
          ],
        ),
      ],
    ),
  );
}

