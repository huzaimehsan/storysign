import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/cover_image_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';

Widget profileHeaderCard({
  required String imagePath,
  required String name,
  required String email,
  required String joinedDate,
  required String plan,
  required String autograph,

  required bool? author,
  VoidCallback? onEdit,
}) {
  final String path = imagePath.trim();

  return Container(
    width: double.infinity,

    padding: EdgeInsets.all(4.5.w),
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(20.sp),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: SizedBox(
            height: 16.w,
            width: 16.w,
            child: CoverImageWidget(
              assetPath: path,
              imageUrl: path.startsWith('http') ? path : null,
              height: 16.w,
              width: 16.w,
              fit: BoxFit.cover,
              fallbackIcon: Icons.person_rounded,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                fontFamily: 'Poppins',
                text: name,
                color: secondryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                overFlow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 0.4.h),
              customText(
                fontFamily: 'Poppins',
                text: email,
                color: secondryColor.withOpacity(0.75),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                overFlow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 0.4.h),
              Row(
                children: [
                  customText(
                    fontFamily: 'Poppins',
                    text: 'Joined: ',
                    color: secondryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  Flexible(
                    child: FormattedRequestDate(
                      dateString: joinedDate.isNotEmpty
                          ? joinedDate
                          : 'Unknown',
                      dateFormat: 'dd MMM, yyyy',
                      color: secondryColor.withOpacity(0.7),
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      overFlow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),
              Row(
                children: [
                  if (author == true)
                    Flexible(
                      child: buttonWidget(
                        plan,
                        buttonColor,
                        onTap: () {},
                        colors: buttonColor.withOpacity(0.15),
                        fontFamily: 'Poppins',
                        height: 2.6.h,
                        borderColor: buttonColor,
                        fontsize: 13.sp,
                        fontweight: FontWeight.w600,
                      ),
                    ),
                  if (author == true) SizedBox(width: 2.w),
                  if (author == true)
                    Flexible(
                      child: buttonWidget(
                        "$autograph Autographs",
                        buttonColor,
                        onTap: () {},
                        isShadow: true,
                        colors: bottomNavColor,
                        fontFamily: 'Poppins',
                        height: 2.7.h,
                        fontsize: 13.sp,
                        fontweight: FontWeight.w500,
                      ),
                    ),
                ],
              ),

              if (author == true) SizedBox(height: 3.h),
            ],
          ),
        ),
        InkWell(
          onTap: onEdit,
          child: Image.asset(
            "assets/png/edit.png",
            height: 4.w,
            width: 4.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}
