import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/helper_functions.dart';
import '../../../../../widgets/background_image.dart';
import '../../../../../widgets/custom_reset_container.dart';
import '../../../../../widgets/custom_text_feild.dart';
import '../../controller/auth_controller.dart';


class ResendOtp extends GetView<AuthController> {
  const ResendOtp({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String email = args is Map<String, dynamic> ? args['email'] ?? "" : "";
    final String code = args is Map<String, dynamic> ? args['code'] ?? "" : "";
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),

          AuthCard(
            title: "Reset Password",
            subtitle: "Enter your new password and confirm it",
            buttonText: "Change Password",
            onButtonPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                controller.resetPassword(email, code);
              }
            },
            Decs: 'Enter a new password and confirm it to update your account.',
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    emailTextFeild(
                      'New Password',
                      "••••••••",
                      controller: controller.newPasswordController,
                      ispassword: true,
                      isPasswordHidden: controller.isPasswordHidden,
                      validator: (value) => HelperFunction.passwordValidate(value ?? ''),
                    ),
                    SizedBox(height: 1.5.h),
                    emailTextFeild(
                      'Confirm Password',
                      "••••••••",
                      controller: controller.confirmNewPasswordController,
                      validator: (value) => HelperFunction.passwordValidate(value ?? ''),
                      ispassword: true,
                      isPasswordHidden: controller.isConfirmPasswordHidden,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
