import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../constants/color_constants.dart';
import 'button_widget.dart';
import 'customText_widget.dart';

Widget planWidget(String plantype,double price,String timeline,String duration,{VoidCallback? onTap, bool? isActive = false, bool? isPlan = false, Widget? child}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    child: InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(
            color: blackColor.withValues(alpha: 0.12),
            width: 0.25.w,
          ),
          borderRadius: BorderRadius.circular(17.sp),

          /// 🔥 ADD THIS
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // light shadow
              blurRadius: 8,  // softness
              spreadRadius: 1, // slight spread
              offset: Offset(0, 3), // shadow below
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              Row(
                children: [
                  customText(
                    text: plantype,
                    color: blueAppBarColor,
                    fontFamily: "bl_melody",
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                    height: 0.13.h,
                  ),
                  Spacer(),
                  customText(
                    text: "\$${price}",
                    color: blueAppBarColor,
                    fontFamily: "bl_melody",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    height: 0.13.h,
                  ),
                ],
              ),
              SizedBox(height: 0.1.h),
              Row(
                children: [
                  customText(
                    text: timeline,
                    fontSize: 15.sp,
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  customText(
                    text: duration,
                    fontSize: 15.sp,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              child ?? Column(
                children: [
                  planWidgetRow("Free delivery"),
                  planWidgetRow("Set schedule"),
                  planWidgetRow("Cancel anytime"),
                  planWidgetRow("Email support"),],
              ),
              SizedBox(height: 2.h),
              isActive == false ?
              buttonWidget(
                isPlan == true ? "Downgrade":"Select Plan",
                blueAppBarColor,
                borderColor: blueAppBarColor,
                fontsize: 15.5.sp,
              ): buttonWidget(
                "Current Plan",
                whiteColor,
                colors: blueColor,
                fontsize: 15.5.sp,
              ),
            ],
          ),
        ),
      ),
    )
  );
}
Widget planWidgetRow(String title){
  return Column(
    children: [
      Row(
        children: [
          Image.asset(
            "assets/png/subscription_image/tick_circle.png",
            width: 6.w,
          ),

          SizedBox(width: 2.w),

          Expanded(
            child: customText(
              text: title,
              fontSize: 15.sp,
              textAlign: TextAlign.start,
              overFlow: TextOverflow.ellipsis
            ),
          ),
        ],
      ),
      SizedBox(height: 0.2.h),
      Divider(
        color: Colors.grey.shade300, // lighter grey
      )
    ],
  );
}
