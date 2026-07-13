import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/auth/controller/auth_controller.dart';
import 'package:storysign/widgets/background_image.dart';

import '../../../../../utils/helper_functions.dart';
import '../../../../../widgets/custom_reset_container.dart';
import '../../../../../widgets/custom_text_feild.dart';

class ResetPassword extends GetView<AuthController> {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),

          AuthCard(
            title: "Forgot Password",
            subtitle: "Enter your email to receive an OTP code",
            buttonText: "Send OTP",
            onButtonPressed: () {
    if (controller.formKey.currentState?.validate() ?? false) {
    controller.forgotPassword();
    }
    },
            Decs:
                'We will send a 6-digit verification code to your registered email address ',
            children: [
              Form(
                key: controller.formKey,

                child: emailTextFeild(
                  'Email',
                  "abc@gmail.com",
                  controller: controller.forgotEmailController,

                  validator: (value) =>
                      HelperFunction.emailValidate(value ?? ''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
