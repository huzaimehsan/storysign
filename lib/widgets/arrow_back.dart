import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';

Widget arrowBack(){
  return InkWell(
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
          color: Colors.grey.shade300
      ),
      child: Image.asset('assets/png/arrow_back.png',color: blackColor,),
    ),
  );
}
