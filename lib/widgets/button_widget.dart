import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'customText_widget.dart';

Widget buttonWidget(
    dynamic text,
    Color textColor, {
      Color? colors,
      double? height,
      double? width,



      VoidCallback? onTap,
      IconData? icon,
      Image? image,
      Color? borderColor,
      double? fontsize,
      FontWeight? fontweight,

      String? fontFamily,
      bool? isGradient,
      bool? isShadow = false
    }) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height ?? 5.5.h,
      width: width ?? 100.w,
      decoration: BoxDecoration(
        color: colors,

        boxShadow: [
          if(isShadow == true)
          BoxShadow(

              color: Colors.black.withOpacity(0.12),
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            // Shadow moves downward
          ),
        ],
        borderRadius: BorderRadius.circular(17.sp),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.2)
            : null, // 👈 Apply only if given

        gradient: isGradient == true
            ? LinearGradient(
          colors: [
            blueAppBarColor,
            blueAppBarColor,               // start color
            purpleColor, // very light purple start
            // full purple at end
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.7, 1], // 🔹 blue ends at 70%, purple fades in till 100%
        )
            : null,
      ),
      child: Center(
        child: image == null ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor,
                size: 16.sp,
              ),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: customText(
                  text: text,
                  fontSize: fontsize != null ? fontsize : 17.sp,
                  fontFamily: fontFamily,
                  color: textColor,
                  fontWeight: fontweight ?? FontWeight.w500,
                  overFlow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ):
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) ...[
              image,
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: customText(
                  text: text,
                  fontSize: fontsize != null ? fontsize : 17.sp,
                  fontFamily: fontFamily,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  overFlow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
