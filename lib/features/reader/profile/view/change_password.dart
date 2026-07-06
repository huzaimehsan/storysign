import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../search/widgets/header_widget.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            customHeader(
              context: context,
              title: "Change Password",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
        
            Padding(padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                SizedBox(height: 1.5.h),
                emailTextFeild('Old Password', "8+ character"),
                SizedBox(height: 1.5.h),
                emailTextFeild('New Password', "8+ character"),
                SizedBox(height: 1.5.h),
                emailTextFeild('Confirm Password', "**********"),
                SizedBox(height: 6.h),
                buttonWidget(
                  "Confirm",
                  whiteColor,
                  onTap: () {
                    showSuccessDialog(
                      ontap: () {
                        Get.back();
                        Get.back();
                      },
                      buttonText: "Okay",
                      context,

                      desc: "Your Password Has Been changed"
                          ,
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
            )
        
          ],
        ),
      ),
    );
  }
}
