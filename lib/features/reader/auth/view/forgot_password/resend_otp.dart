import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),

          AuthCard(
            title: "Reset Password",
            subtitle: "Enter your new password and confirm it",
            buttonText: "Change Password",
            onButtonPressed: (){

              controller.resetPassword(email, code);
            },
            Decs: 'Enter a new password and confirm it to update your account.',
            children: [
              emailTextFeild(
                'New Password',
                "••••••••",
                controller: controller.newPasswordController,
                ispassword: true,
                isPasswordHidden: controller.isPasswordHidden,
              ),
              emailTextFeild(
                'Confirm Password',
                "••••••••",
                controller: controller.confirmNewPasswordController,
                ispassword: true,
                isPasswordHidden: controller.isConfirmPasswordHidden,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
