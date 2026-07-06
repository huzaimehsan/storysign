import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/request/widget/all_pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../../../widgets/sucess_widget.dart';

class RequestDetail extends StatelessWidget {
  const RequestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // Yahan 'start' lagana zaroori hai
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customHeaderAuthor(
                    context: context,
                    title: 'Request Detail',
                    onBack: () => Get.back(),
                    onIconPressed: () {},
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    height: 1.0, // 100% of 16px
                    letterSpacing: 0.0,
                    text: "Reader",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
        
            AllPendingRequest(
              imagePath: "assets/png/searchprofile.png",
              authorName: "Jane Austen",
              bookName: "Member: 10 jan,2024",
              date: "28 june, 2026",
              ontap: () {},
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                text: "Ebook Detail",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: whiteColor,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 0.5.h),
            eBookDetail(
              imagePath: "assets/icon/bookdetail.png",
              bookName: "Member: 10 jan,2024",
              authorName: "Jane Austen",
            ),
            SizedBox(height: 2.h),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                height: 1.0, // 100% of 16px
                letterSpacing: 0.0,
                text: "Personal Message",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: whiteColor,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 2.h),
            signedCopyMessageCard(
              message:
                  "I've read your previous works and they changed my life. My daughter is turning 16 next week. Could you write something encouraging about following your dreams?",
              margin: EdgeInsets.symmetric(horizontal: 4.w),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  SizedBox(height: 18.h),
                  buttonWidget(
                    "Accept Request",
                    whiteColor,
                    onTap: () {
                      Navigator.of(context).pushNamed('/pdfReview');
                    },
                    colors: buttonColor,
                    fontFamily: 'Poppins',
                    height: 5.2.h,
                    width: double.infinity,
                    fontsize: 16.sp,
                    fontweight: FontWeight.w600,
                  ),
                  SizedBox(height: 2.h),
                  buttonWidget(
                    "Decline Request",
                    whiteColor,
                    onTap: () {

                      showDeclineDialog(
                        context,
                        desc: "Are you sure you want to decline this request?",
                        buttonText: "Confirm",
                        ontap: () {
                          // Your decline logic goes here
                          Get.back();
                        },
                      );
                    },
                    colors: greyColor,
                    fontFamily: 'Poppins',
                    height: 5.2.h,
                    width: double.infinity,
                    fontsize: 16.sp,
                    fontweight: FontWeight.w600,
                  ),
                ],
              ),
            ),
        
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
