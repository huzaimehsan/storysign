import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/background_image.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';


class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),

          Align(
            alignment: Alignment.center,
            child: Container(
              width: 90.w,
              // 🔥 PURI SCREEN KE LIYE UNIFORM PADDING
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: customText(
                        color: white,
                        fontFamily: 'Poppins',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        text: "Create Account",
                        height: 1.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    SizedBox(height: 2.5.h),

                    // Fields
                    emailTextFeild('Full Name', "Lisa Jhon"),
                    SizedBox(height: 1.5.h), // Consistent gap
                    emailTextFeild('Email', "abc@gmail.com"),
                    SizedBox(height: 1.5.h),
                    emailTextFeild('Password', "8+ character"),
                    SizedBox(height: 1.5.h),
                    emailTextFeild('Confirm Password', "**********"),

                    SizedBox(height: 3.h),
                    buttonWidget(
                      "Sign Up",
                      Colors.white,
                      onTap: () => Get.toNamed('/chooserole'),
                      colors: buttonColor,
                      fontFamily: 'Poppins',
                      height: 5.5.h,
                      width: double.infinity,
                      fontsize: 16.sp,
                      fontweight: FontWeight.w600,
                    ),

                    SizedBox(height: 2.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText(
                          color: lightTextColor,
                          fontSize: 15.sp,
                          text: "Already have an account? ",
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed('/signin'),
                          child: customText(
                            color: white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            text: "Sign In",
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Divider section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.1.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: textFeildColor, thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: customText(
                              text: "Continue with",
                              color: lightTextColor,
                              fontSize: 14.sp,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Divider(color: textFeildColor, thickness: 1),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Row(
                      children: [
                        Expanded(
                          child: buttonWidget(
                            "Apple",
                            whiteColor,
                            colors: buttonColor,
                            height: 5.2.h,
                            fontsize: 16.sp,
                            fontFamily: "Poppins",
                            fontweight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: buttonWidget(
                            "Google",
                            buttonColor,
                            colors: whiteColor,
                            height: 5.2.h,
                            fontsize: 16.sp,
                            fontweight: FontWeight.w600,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
