import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'customText_widget.dart';


class AuthorInfoCard extends StatelessWidget {
  final String? imagePath;
  final String bookTitle;
  final dynamic date;

  const AuthorInfoCard({
    super.key,
    required this.imagePath,
    required this.bookTitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate;

    if (date is DateTime) {
      formattedDate = 'Joined ${DateFormat('dd MMM yyyy').format(date as DateTime)}';
    } else if (date is String && (date as String).trim().isNotEmpty) {
      final text = (date as String).trim();
      formattedDate = text.startsWith('Joined') ? text : 'Joined $text';
    } else {
      formattedDate = 'Joined recently';
    }

    final String path = imagePath?.toString() ?? "";

    // 1. ImageProvider define karein
    ImageProvider? imageProvider;
    bool isPlaceholder = (path.isEmpty || path == "null");

    if (!isPlaceholder) {
      if (path.startsWith('http')) {
        imageProvider = NetworkImage(path);
      } else if (path.startsWith('/')) {
        imageProvider = FileImage(File(path));
      } else {
        imageProvider = AssetImage(path);
      }
    }
    return Container(
      height: 9.5.h,
      width: 100.w,
      margin: EdgeInsets.fromLTRB(4.w, 0.8.h, 4.w, 0),
      padding: EdgeInsets.all(4.5.w),
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

              color: isPlaceholder ? Colors.grey.withOpacity(0.2) : null,
              image: !isPlaceholder
                  ? DecorationImage(image: imageProvider!, fit: BoxFit.cover)
                  : null,
            ),

            child: isPlaceholder
                ? Center(
              child: Icon(Icons.person_rounded, color: buttonColor.withOpacity(0.6), size: 9.w),
            )
                : null,
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
                SizedBox(height: 0.3.h),
                customText(
                  fontFamily: "Poppins",
                  text: formattedDate,
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