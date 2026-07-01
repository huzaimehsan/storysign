import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/widgets/reader/request_detail_widget.dart';
import 'package:storysign/features/reader/Home/widgets/reader/custom_text_field_with_limit.dart';
import 'package:storysign/features/reader/Home/widgets/reader/fee_field_with_price.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/custom_text_feild.dart';
import '../../../search/widgets/author_detail_widget.dart';
import '../../../search/widgets/header_widget.dart';

class RequestDetail extends StatelessWidget {
  const RequestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Autograph Request",
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
            ),
            SizedBox(height: 7.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: buttonWidget(
                "Make Payment",
                whiteColor,
                onTap: () => Get.toNamed('/makepayment'),
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
