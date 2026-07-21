import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/cover_image_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';

class AllPendingRequest extends StatelessWidget {
  final String imagePath;
  final String authorName;

  final String date;

  final VoidCallback ontap;
  final String bookName;

  const AllPendingRequest({
    super.key,
    required this.imagePath,

    required this.authorName,
    required this.bookName,
    required this.date,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imagePath.trim().isNotEmpty;
    final bool isNetworkImage = hasImage && (imagePath.startsWith('http://') || imagePath.startsWith('https://'));
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.1.h),
        child: Container(
          height: 9.8.h,
          width: 100.w,
          margin: EdgeInsets.fromLTRB(4.w, 0.8.h, 4.w, 0),
          padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 4.w),
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
                height: 6.h,
                width: 6.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor.withOpacity(0.1),
                ),
                child: hasImage
                    ? ClipOval(
                        child: isNetworkImage
                            ? Image.network(
                                imagePath,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.person,
                                  color: buttonColor,
                                  size: 3.h,
                                ),
                              )
                            : Image.asset(
                                imagePath,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.person,
                                  color: buttonColor,
                                  size: 3.h,
                                ),
                              ),
                      )
                    : Icon(
                        Icons.person,
                        color: buttonColor,
                        size: 3.h,
                      ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      fontFamily: "Poppins",
                      text: authorName,
                      color: secondryColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.4.h),
                    customText(
                      fontFamily: "Poppins",
                      text: bookName,
                      color: primaryColor.withOpacity(0.7),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 0.4.h),
                  ],
                ),
              ),

              FormattedRequestDate(
                dateString: date,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget eBookDetail({
  required String? imagePath,
  required String? bookName,
  required String? authorName,
}) {
  String? imageUrl;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 0.1.h),
    child: Container(
      height: 9.7.h,
      width: 100.w,
      margin: EdgeInsets.fromLTRB(4.w, 0.8.h, 4.w, 0),
      padding: EdgeInsets.symmetric(vertical: 3.6.w, horizontal: 4.w),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: CoverImageWidget(
              imageUrl: imageUrl,
              assetPath: imagePath!,
              height: 12.h,
              width: 17.w,
              fit: BoxFit.cover,
            ),

          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  fontFamily: "Poppins",
                  text: bookName,
                  color: secondryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 0.4.h),
                customText(
                  fontFamily: "Poppins",
                  text: authorName,
                  color: primaryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 0.4.h),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
