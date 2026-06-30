import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/widgets/background_image.dart';

import '../../../../../widgets/custom_reset_container.dart';
import '../../../../../widgets/custom_text_feild.dart';


class ResetPassword extends StatelessWidget {
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
            onButtonPressed: () => Get.toNamed('/sendotp'),
             Decs: 'We will send a 6-digit verification code to your registered email address ',
            children: [
              emailTextFeild('Email', "abc@gmail.com"),


            ],
          )


        ],
      ),
    );
  }
}

