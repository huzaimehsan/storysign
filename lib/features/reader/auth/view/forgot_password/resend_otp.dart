import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/background_image.dart';
import '../../../../../widgets/custom_reset_container.dart';
import '../../../../../widgets/custom_text_feild.dart';


class ResendOtp extends StatelessWidget {
  const ResendOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          BackgroundImage(),

          AuthCard(
            title: "Reset Password",
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
