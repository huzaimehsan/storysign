import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'customText_widget.dart';

Widget appBar(String title, {bool? isBack = true, double? height, double? padding, bool? isHome = false, bool? isSearch = true}){
  return Container(
    height: height ?? 15.h,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(9.w),
        bottomRight: Radius.circular(9.w),
      ),
      gradient: LinearGradient(
        colors: [
          blueAppBarColor.withOpacity(1),  // 80% opacity
          blueAppBarColor.withOpacity(0.95),  // 80% opacity
          redAppBarColor.withOpacity(0.9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.only(top: 4.h, left: 5.w, right: 5.w, bottom: padding ?? 0),
      child: isHome == false ?
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  color: whiteColor.withValues(alpha: 0.12)
              ),
              child: Image.asset('assets/png/arrow_back.png'),
            ),
          ),
          // SizedBox(width: 8.w,),
          Spacer(),
          customText(
              text: title,
              fontSize: 18.sp,
              color: whiteColor,
              fontWeight: FontWeight.w700,
              fontFamily: "bl_melody"
          ),
          // SizedBox(width: 8.w,),
          Spacer(),

          if(isSearch == true)
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              height: 5.h,
              width: 12.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFFFF).withValues(alpha: 0.12)
              ),
              child: Image.asset('assets/png/search.png'),
            ),
          ),
          InkWell(
            onTap: (){
              Get.toNamed("notifications");
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  height: 5.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFFFFF).withValues(alpha: 0.12)
                  ),
                  child: Image.asset('assets/png/noti.png'),
                ),
                Positioned(
                    top: 0.8.h,
                    right: 2.2.w,
                    child: Container(
                      height: 1.25.h,
                      width: 4.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: redColor
                      ),
                    )
                )
              ],
            ),
          )
        ],
      ):
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 5.5.h,
            width: 12.25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow
            ),
            child: Image.asset("assets/png/home/profile.png", fit: BoxFit.contain,),
          ),
          SizedBox(width: 2.25.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customText(
                  text: "Welcome back",
                  fontSize: 14.5.sp,
                  color: yellowColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: "inter",
                  letterSpacing: -0.5
              ),
              customText(
                  text: "Hi, ${title}",
                  fontSize: 17.5.sp,
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: "bl_melody",
                letterSpacing: -0.5,
                overFlow: TextOverflow.ellipsis
              ),
            ],
          ),
          SizedBox(width: 3.w,),
          Image.asset("assets/png/home/hi_icon.png", height: 2.75.h, width: 5.75.w,),
          Spacer(),

          InkWell(

            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              height: 5.h,
              width: 12.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFFFF).withValues(alpha: 0.12)
              ),
              child: Image.asset('assets/png/search.png'),
            ),
          ),
          InkWell(
            onTap: (){
              Get.toNamed("notifications");
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  height: 5.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFFFFF).withValues(alpha: 0.12)
                  ),
                  child: Image.asset('assets/png/noti.png'),
                ),
                Positioned(
                    top: 0.8.h,
                    right: 2.2.w,
                    child: Container(
                      height: 1.25.h,
                      width: 4.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: redColor
                      ),
                    )
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
