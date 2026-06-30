import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';



class WidgetSelectAuthor extends StatelessWidget {
  final String imagePath;
  final String bookTitle;
  final String activity;
  final VoidCallback authorDetail;
  final String date;

  const WidgetSelectAuthor({
    super.key,
    required this.imagePath,
    required this.bookTitle,
    required this.activity,
    required this.date,
    required this.authorDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.3.h),
      child: Container(
        height: 15.h,
        width: 100.w,
        margin: EdgeInsets.fromLTRB(4.w, 0.8.h, 4.w, 0),
        padding: EdgeInsets.symmetric(horizontal: 5.w ,vertical: 4.w),
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
              height: 10.h,
              width: 10.h,
              decoration: BoxDecoration(

                border: Border.all(
                  color: activity == 'Active' ? buttonColor : Color(0xFFACACAC),
                  width: 1.2,

                ),
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

                  SizedBox(height: 0.4.h),


                  customText(
                    fontFamily: "Poppins",
                    text: activity,
                    color: buttonColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),

                  SizedBox(height: 0.4.h),
                  customText(
                    fontFamily: "Poppins",
                    text: date,
                    color: secondryColor.withOpacity(0.7),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 1.h),

                  buttonWidget(
                    "Select",
                    activity == 'Active' ? whiteColor : whiteColor,
                    onTap: () {},
                    colors: activity == 'Active' ? buttonColor : Color(0xFFACACAC),
                    fontFamily: 'Poppins',
                    height: 2.7.h,
                    width: 18.w,
                    borderColor: activity == 'Active' ? buttonColor : Color(0xFFACACAC),
                    fontsize: 14.sp,
                    fontweight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}