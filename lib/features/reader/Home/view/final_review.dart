import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/widgets/reader/request_detail_widget.dart';
import 'package:storysign/features/reader/Home/widgets/reader/custom_text_field_with_limit.dart';
import 'package:storysign/features/reader/Home/widgets/reader/fee_field_with_price.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../search/widgets/author_detail_widget.dart';
import '../../search/widgets/header_widget.dart';

class FinalReview extends StatelessWidget {
  const FinalReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Final Review",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                fontFamily: "Poppins",
                text: "Book Detail",
                color: whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            RequestDetailWidget(
              imagePath: "assets/png/book.png",
              bookTitle: "The Great Gatsby", status: '',
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                fontFamily: "Poppins",
                text: "About Author",
                color: whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            AuthorInfoCard(
              imagePath: "assets/png/searchprofile.png",
              bookTitle: "Matt Haig",
              date: "Joined: 22 june, 2026",
            ),
            SizedBox(height: 1.h),
            CustomTextFieldWithLimit(
              label: 'Personal Message',
              hintText: "Write a personal message to the author about why this book is special to you…",
              maxLength: 200,
              maxLines: 4,
            ),
            SizedBox(height: 1.5.h),
            FeeFieldWithPrice(
              label: 'Signature Price',
              price: "Fee",
              isPaid: true,
            ),
            SizedBox(height: 7.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: buttonWidget(
                "Submit Request",
                whiteColor,
                onTap: () {
                  showSuccessDialog(context,desc: "Your Autograph Request have been sent Successfully",buttonText: "okay",


                  ontap:
                  (){
                    Get.back();
                    Get.toNamed("/bottomnav");
                  }
                  );
                },
                colors: buttonColor,
                fontFamily: 'Poppins',
                height: 5.2.h,
                width: double.infinity,
                fontsize: 16.sp,
                fontweight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }


}
