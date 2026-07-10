import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/auth/controller/auth_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/background_image.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';

class SignUp extends GetView<AuthController> {
  const SignUp({super.key});



  @override
  Widget build(BuildContext context) {
    final String role = Get.arguments ?? 'reader';
    final bool isAuthor = role == 'author';
    final authController = controller;



    return Scaffold(

      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          BackgroundImage(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 3.h,
                ),
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: 90.w,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: customText(
                          color: white,
                          fontFamily: 'Poppins',
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                          text: "Create Account",
                          height: 1.0,
                          letterSpacing: 0.0,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 25.w,
                              width: 25.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: textFeildContainColor,
                                border: Border.all(
                                  color: whiteColor.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: Obx(() {
                                  final file = authController.profileImage.value;
                                  return file != null
                                      ? Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                          width: 20.w,
                                          height: 20.w,
                                        )
                                      : Container(
                                          color: Colors.grey.withOpacity(0.2),
                                          child: Center(
                                            child: Icon(
                                              Icons.person_rounded,
                                              color: buttonColor.withOpacity(0.6),
                                              size: 12.w,
                                            ),
                                          ),
                                        );
                                }),
                              ),
                            ),
                            Positioned(
                              right: -1.w,
                              bottom: 2.w,
                              child: GestureDetector(
                                onTap: () async {
                                  await authController.pickProfilePicture(context);
                                },
                                child: Image.asset(
                                  "assets/png/camera.png",
                                  height: 8.w,
                                  width: 8.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      // Fields
                      emailTextFeild(
                        'Full Name',
                        "Lisa Jhon",
                        controller: authController.fullNameController,
                      ),
                      SizedBox(height: 1.5.h),
                      emailTextFeild(
                        'Email',
                        "abc@gmail.com",
                        controller: authController.emailController,
                      ),
                      SizedBox(height: 1.5.h),
                      emailTextFeild(
                        'Password',
                        "8+ character",
                        controller: authController.passwordController,
                        ispassword: true,
                        isPasswordHidden: authController.isPasswordHidden,
                      ),
                      SizedBox(height: 1.5.h),
                      emailTextFeild(
                        'Confirm Password',
                        "**********",
                        controller: authController.confirmPasswordController,
                        ispassword: true,
                        isPasswordHidden: authController.isConfirmPasswordHidden,
                      ),

                      if (isAuthor) ...[
                        SizedBox(height: 1.5.h),
                        emailTextFeild('Bio Graphy', "Write about yourself",controller: authController.bioController),
                      ],

                      SizedBox(height: 3.h),
                      buttonWidget(
                        "Sign Up",
                        whiteColor,
                        onTap: () => authController.signUp(context, role: role),
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
                              child: Divider(
                                color: textFeildColor,
                                thickness: 1,
                              ),
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
                              child: Divider(
                                color: textFeildColor,
                                thickness: 1,
                              ),
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
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


