
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../components/cover_image_widget.dart';
import '../../../../widgets/customText_widget.dart';


class SearchAuthorCard extends StatelessWidget {
  final dynamic imagePath;
  final String bookTitle;
  final VoidCallback requestAutoGraph;

  final VoidCallback authorDetail;
  final String date;

  const SearchAuthorCard({
    super.key,
    required this.imagePath,
    required this.bookTitle,

    required this.date, required this.requestAutoGraph, required this.authorDetail,
  });

  @override
  Widget build(BuildContext context) {
    final String path = imagePath?.toString() ?? "";
    final imageWidget = CoverImageWidget(
      assetPath: path,
      imageUrl: path.startsWith('http') ? path : null,
      height: 10.h,
      width: 9.8.h,
      fit: BoxFit.cover,
      fallbackIcon: Icons.person_rounded,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.3.h),
      child: Container(
        height: 13.2.h,
        width: 100.w,
        margin: EdgeInsets.fromLTRB(4.w, 0.8.h, 4.w, 0),
        padding: EdgeInsets.only(top: 4.w,bottom: 4.w,right: 4.w,left:4.w ),
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
              height: 9.7.h,
              width: 9.6.h,
              decoration: BoxDecoration(
                border: (path.isEmpty || path == "null")
                    ? Border.all(color: Color(0xFFACACAC), width: 1.2)
                    : null,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: imageWidget,
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
                    overFlow : TextOverflow.ellipsis,
                    color: secondryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: 0.4.h),
                  customText(
                    fontFamily: "Poppins",
                    text: date,
                    color: secondryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 1.h),
                  buttonWidget(
                    onTap: requestAutoGraph,
                    "Request Autograph",
                    whiteColor,
                    colors: buttonColor,
                    fontFamily: 'Poppins',
                    height: 3.4.h,
                    width: 35.w,
                    borderColor: buttonColor,
                    fontsize: 14.sp,
                    fontweight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap:  authorDetail,
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
}