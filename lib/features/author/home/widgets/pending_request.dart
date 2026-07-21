import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';

class PendingRequest extends StatelessWidget {
  final String imagePath;
  final String authorName;
  final VoidCallback authorDetail;
  final String date;
  final String bookName;

  const PendingRequest({
    super.key,
    required this.imagePath,
    required this.date,
    required this.authorDetail,
    required this.authorName,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context) {
    // Check karein ke imagePath khali toh nahi hai
    bool hasImage = imagePath.trim().isNotEmpty;

    return InkWell(
      onTap: authorDetail, // Yahan onep tap pure card par bhi laga sakte hain agar zaroorat ho
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.1.h),
        child: Container(
          height: 12.5.h,
          width: 100.w,
          margin: EdgeInsets.fromLTRB(4.w, 0.8.h, 4.w, 0),
          padding: EdgeInsets.only(top: 3.w, bottom: 3.w, left: 3.w, right: 5.w),
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
              // Image Container with Condition & Placeholder
              Container(
                width: 10.h,
                height: 10.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor.withAlpha(30),
                ),
                child: hasImage
                    ? ClipOval(
                        child: Image.network(
                          imagePath,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            color: buttonColor,
                            size: 4.h,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: buttonColor,
                        size: 4.h,
                      ),
              ),

              
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(
                      fontFamily: "Poppins",
                      text: authorName,
                      color: secondryColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.5.h),
                    customText(
                      fontFamily: "Poppins",
                      text: bookName,
                      color: primaryColor.withOpacity(0.7),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 0.5.h),
                    FormattedRequestDate(
                      dateString: date,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 0.6.h),
                  ],
                ),
              ),
              GestureDetector(
                onTap: authorDetail,
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
      ),
    );
  }
}