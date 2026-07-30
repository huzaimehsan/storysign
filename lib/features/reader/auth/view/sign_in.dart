import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/features/reader/auth/controller/auth_controller.dart';

import '../../../../utils/helper_functions.dart';
import '../../../../widgets/background_image.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';


class SignIn extends GetView<AuthController> {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = controller;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),

          Align(
            alignment: Alignment.center,
            child:
            Container(
              width: 90.w,
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
                        text: "Sign In",
                        height: 1.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    SizedBox(height: 2.5.h),

                    Form(
                      key: authController.signInFormKey,
                      child: Column(
                        children: [
                          emailTextFeild(
                            'Email',
                            "abc@gmail.com",
                            controller: authController.signInEmailController,
                            validator: (value) => HelperFunction.emailValidate(value ?? ''),
                          ),
                          SizedBox(height: 2.h),
                          emailTextFeild(
                            'Password',
                            "••••••••",
                            controller: authController.signInpasswordController,
                            ispassword: true,
                            isPasswordHidden: authController.isConfirmPasswordHidden,
                            validator: (value) => HelperFunction.passwordValidate(value ?? ''),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.3.h),
                    InkWell(
                      onTap: () => Get.toNamed('/reset'),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: customText(
                          color: lightTextColor,
                          fontFamily: 'Inter',
                          fontSize: 14.sp, // .sp
                          fontWeight: FontWeight.w500,
                          text: "Forgot Password?",
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    buttonWidget(
                      "Sign In",
                      whiteColor,
                      onTap: () {
                        if (authController.signInFormKey.currentState?.validate() ?? false) {
                          authController.login();
                        }
                      },
                      colors: buttonColor,
                      fontFamily: 'Poppins',
                      height: 5.2.h, // Thoda height badhayi
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
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          text: "Don’t have an account?  ",
                        ),
                        GestureDetector( // 💡 Tap effect ke liye
                          onTap: () => Get.toNamed('/chooserole'),
                          child: customText(
                            color: white,
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            text: "Sign Up",
                          ),
                        ),
                      ],
                    )
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
