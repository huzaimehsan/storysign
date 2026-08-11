import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart' as Colors;
import '../../../../../widgets/customText_widget.dart';

Widget buildInfoCard({
  required String imagePath,
  required String title,
  required String subtitle,
  required String date,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image
      Image.asset(imagePath, width: 15.w, height: 15.w),
      SizedBox(width: 3.w),

      // Column with 3 text parameters
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              fontFamily: "Poppins",
              text: title,
              color: Colors.secondryColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 0.3.h),
            customText(
              fontFamily: "Poppins",
              text: subtitle,
              color: Colors.secondryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 0.3.h),
            customText(
              fontFamily: "Poppins",
              text: date,
              color: Colors.primaryColor.withOpacity(0.7),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    ],
  );
}
