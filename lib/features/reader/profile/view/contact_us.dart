import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../search/widgets/header_widget.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            customHeader(
              context: context,
              title: "Contact Us",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  SizedBox(height: 1.5.h),
                  emailTextFeild('Name', "John Smith"),
                  SizedBox(height: 1.5.h),
                  emailTextFeild('Email', "jhonsmith@gmail.com"),
                  SizedBox(height: 1.5.h),
                  emailTextFeild(
                    'Message',
                    "Write your message here.",
                    maxLength: 4,
                    maxLines: 5,
                  ),
                  SizedBox(height: 6.h),
                  buttonWidget(
                    "Send Message",
                    whiteColor,
                    onTap: () {
                      showSuccessDialog(
                        ontap: () {
                          Get.back();
                          Get.back();
                        },
                        buttonText: "Okay",
                        context,

                        desc: "Your Profile have been updated Suscessfully",
                      );
                    },
                    colors: buttonColor,
                    fontFamily: 'Poppins',
                    height: 5.2.h,
                    width: double.infinity,
                    fontsize: 16.sp,
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
