import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';


class AuthorInfoCard extends StatelessWidget {
  final String imagePath;
  final String bookTitle;
  final String date;

  const AuthorInfoCard({
    super.key,
    required this.imagePath,
    required this.bookTitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      width: 100.w,
      margin: EdgeInsets.fromLTRB(4.w, 0.8.h, 4.w, 0),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 7.h,
            width: 7.h,
            decoration: BoxDecoration(
              border: Border.all(color: buttonColor, width: 1.2),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  fontFamily: "Poppins",
                  text: bookTitle,
                  color: secondryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 0.6.h),
                customText(
                  fontFamily: "Poppins",
                  text: date,
                  color: secondryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthorBiographyCard extends StatelessWidget {
  final String description;

  const AuthorBiographyCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.fromLTRB(5.w, 0.8.h, 5.w, 0),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            fontFamily: "Poppins",
            text: "Biography: ",
            color: secondryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 1.h),
          customText(
            fontFamily: "Poppins",
            text: description,
            color: secondryColor.withOpacity(0.7),
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}