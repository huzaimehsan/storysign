import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/utils/helper_functions.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';

import '../../../reader/search/widgets/header_widget.dart';
import '../controller/change_password_controller.dart';

class ChangePassword extends GetView<ChangePasswordController> {
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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    SizedBox(height: 1.5.h),
                    emailTextFeild(
                      'Old Password',
                      "8+ character",
                      ispassword: true,
                      controller: controller.oldPasswordController,
                      isPasswordHidden: controller.isOldPasswordHidden,
                      validator: (value) =>
                          HelperFunction.passwordValidate(value ?? ''),
                    ),
                    SizedBox(height: 1.5.h),
                    emailTextFeild(
                      'New Password',
                      "8+ character",
                      controller: controller.newPasswordController,
                      isPasswordHidden: controller.isNewPasswordHidden,
                      ispassword: true,
                      validator: (value) =>
                          HelperFunction.passwordValidate(value ?? ''),
                    ),
                    SizedBox(height: 1.5.h),
                    emailTextFeild(
                      'Confirm Password',
                      "••••••••",
                      ispassword: true,
                      controller: controller.confirmPasswordController,
                      isPasswordHidden: controller.isConfirmPasswordHidden,
                      validator: (value) =>
                          HelperFunction.passwordValidate(value ?? ''),
                    ),
                    SizedBox(height: 6.h),
                    buttonWidget(
                      "Confirm",
                      whiteColor,
                      onTap: () {
                        if (controller.formKey.currentState?.validate() ??
                            false) {
                          controller.changePassword();
                        }
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
            ),
          ],
        ),
      ),
    );
  }
}
