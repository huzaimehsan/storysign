
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'button_widget.dart';
import 'customText_widget.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'button_widget.dart';
import 'customText_widget.dart';
import 'formatted_date_widget.dart';

Widget recentlySignedBooks({
  required String imagePath,
  String? imageUrl,
  required String bookTitle,
  String authorName = '',
  required String date,
  VoidCallback? trackRequest,
  required String status,
  EdgeInsetsGeometry? margin,
  bool? iconBadge,
  bool showArrow = true,
  bool showPaidLabel = false,
  String? signed,
  bool showAuthor = false,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
    child: Container(
      height: 15.7.h,
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: _buildCoverImage(imagePath, imageUrl),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: customText(
                    fontFamily: "Poppins",
                    text: bookTitle,
                    color: secondryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
                if (showAuthor && authorName.isNotEmpty) ...[
                  SizedBox(height: 0.6.h),
                  customText(
                    fontFamily: "Poppins",
                    text: authorName,
                    color: primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
                SizedBox(height: 0.6.h),

                FormattedRequestDate(
                  dateString: date, // Yeh ab raw date string legi (jaise book.uploadDate.toString())
                  dateFormat: 'dd MMM, yyyy',
                  color:  secondryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 1.h),
                buttonWidget(
                  status,
                  buttonColor,
                  colors: buttonColor.withOpacity(0.2),
                  fontFamily: 'Poppins',
                  height: 3.h,
                  width: 20.w,
                  borderColor: buttonColor,
                  fontsize: 14.sp,
                  fontweight: FontWeight.w600,
                ),
              ],
            ),
          ),

          // Trailing area: Paid label > Arrow > kuch nahi
          if (showPaidLabel)
            customText(
              fontFamily: "Poppins",
              text: "Paid",
              color: Colors.green,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            )
          else if (showArrow && signed != 'signed')
            InkWell(
              onTap: trackRequest,
              child: Image.asset(
                "assets/icon/arrowicon.png",
                height: 4.h,
                width: 6.w,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildCoverImage(String imagePath, String? imageUrl) {
  final String path = imageUrl?.trim().isNotEmpty == true ? imageUrl!.trim() : imagePath.trim();
  final uri = Uri.tryParse(path);
  final isNetwork = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  final String resolvedPath = isNetwork && uri.host == 'localhost' && Platform.isAndroid
      ? path.replaceFirst('localhost', '10.0.2.2')
      : path;

  Widget placeholder() {
    return Container(
      height: 12.h,
      width: 25.w,
      color: Colors.grey.withOpacity(0.2),
      child: Center(
        child: Icon(
          Icons.book_rounded,
          color: buttonColor.withOpacity(0.6),
          size: 12.w,
        ),
      ),
    );
  }

  if (path.isEmpty || path == 'null') {
    return placeholder();
  } else if (isNetwork) {
    return Image.network(
      resolvedPath,
      height: 12.h,
      width: 25.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        final fallbackUri = Uri.tryParse(imagePath);
        final fallbackIsNetwork = fallbackUri != null && (fallbackUri.scheme == 'http' || fallbackUri.scheme == 'https');
        if (imagePath.trim().isEmpty || imagePath == 'null' || fallbackIsNetwork || imagePath.startsWith('/')) {
          return placeholder();
        }
        return Image.asset(
          imagePath,
          height: 12.h,
          width: 25.w,
          fit: BoxFit.cover,
          errorBuilder: (context, err, stack) => placeholder(),
        );
      },
    );
  } else if (path.startsWith('/')) {
    return Image.file(
      File(path),
      height: 12.h,
      width: 25.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  } else {
    return Image.asset(
      path,
      height: 12.h,
      width: 25.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }
}

Widget signedCopyMessageCard({
  String? title, // String? (Nullable)
  required String message,

  EdgeInsetsGeometry? margin,
}) {
  return Padding(
    padding: margin ?? EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Agar title null nahi hai, tabhi text show karo
          if (title != null && title.isNotEmpty) ...[
            customText(
              fontFamily: "Poppins",
              text: title,
              color: secondryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 1.2.h),
          ],

          customText(
            fontFamily: "Poppins",
            text: message,
            color: secondryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),
  );
}