import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

Widget customHeaderAuthor({
  required BuildContext context,
  required String title,


  required VoidCallback onBack,
  required VoidCallback onIconPressed,
}) {
  return Container(
    padding: EdgeInsets.only(top: 6.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Back Button
        GestureDetector(
          onTap: onBack,
          child: Icon(Icons.arrow_back_ios, color: whiteColor, size: 4.w),
        ),

        // 2. Custom Title Text
        Expanded(
          child: Center(
            child: customText(
              text: title,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: whiteColor,
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // 3. Custom Image/Icon

      ],
    ),
  );
}