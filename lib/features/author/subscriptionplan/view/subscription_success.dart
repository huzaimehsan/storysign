import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';

class SubscriptionSuccessScreen extends StatelessWidget {
  const SubscriptionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            customHeaderAuthor(
              context: context,
              title: 'Subscription',
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 6.h),
            Icon(Icons.check_circle, color: buttonColor, size: 22.w),
            SizedBox(height: 2.h),
            customText(
              text: 'Subscription Confirmed',
              fontFamily: 'Poppins',
              color: secondryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 1.h),
            customText(
              text: 'Your plan has been selected successfully.',
              fontFamily: 'Poppins',
              color: primaryColor.withOpacity(0.7),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            buttonWidget(
              'Continue',
              whiteColor,
              onTap: () => Get.toNamed('/authorbottomnav'),
              colors: buttonColor,
              fontFamily: 'Poppins',
              height: 5.h,
              width: double.infinity,
              fontsize: 15.sp,
              fontweight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
