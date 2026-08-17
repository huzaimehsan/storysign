import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/components/cover_image_widget.dart';
import 'package:storysign/constants/color_constants.dart';

import '../../../../../widgets/customText_widget.dart';

Widget userProfileCard({
  required dynamic imagePath,
  required String name,
  required VoidCallback ontap,
}) {
  final displayName = name.trim().isEmpty
      ? 'Author'
      : (name.contains(" ") ? name.replaceFirst(" ", "\n") : name);

  return InkWell(
    onTap: ontap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 6.2.h,
              width: 6.2.h,
              decoration: BoxDecoration(
                color: buttonColor.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CoverImageWidget(
                  assetPath: '',
                  imageUrl: imagePath?.toString(),
                  height: 6.2.h,
                  width: 6.2.h,
                  fit: BoxFit.cover,
                  fallbackIcon: Icons.person_rounded,
                  placeHolderIconColor: white,
                  placeHolderColor: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),

            Positioned(
              right: 0.1.h,
              bottom: 0.5.h,
              child: Container(
                height: 1.2.h,
                width: 1.2.h,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.3.h),

        SizedBox(
          width: 18.w,
          child: customText(
            color: whiteColor,
            fontFamily: 'Inter',
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w600,
            text: displayName,
            maxLines: 2,
            overFlow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget sectionHeader({required String title, required VoidCallback onSeeAll}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      customText(
        text: title,
        fontSize: 16.sp,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: whiteColor,
      ),
      InkWell(
        onTap: onSeeAll,
        child: customText(
          fontFamily: "Poppins",
          text: "View All >",
          color: iconColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
