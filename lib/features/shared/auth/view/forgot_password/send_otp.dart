import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';


import '../../../../../constants/color_constants.dart';
import '../../../../../utils/helper_functions.dart';
import '../../../../../widgets/background_image.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/otp_text_feild.dart';
import '../../controller/auth_controller.dart';


class SendOtp extends GetView<AuthController> {
  const SendOtp({super.key});


  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String email = args is Map<String, dynamic> ? args['email'] ?? "" : "";
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),

          Align(
            alignment: Alignment.center,
            child: Container(
              width: 90.w,
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
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
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        text: "Verify OTP",
                        height: 1.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    Center(
                      child: customText(
                        color: white,
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        text: "Enter the OTP to verify",
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    customText(
                      text: "OTP",
                      fontSize: 15.sp,
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      fontFamily: "Poppins",
                    ),
                    SizedBox(height: 1.h),
                    Form(
                      key: formKey,
                      child: CustomOtpField(
                        length: 6,
                        validator: (value) => HelperFunction.validateOTP(value ?? ''),
                        onCompleted: (pin) {
                          controller.otpController;
                        },
                      ),
                    ),

                    SizedBox(height: 2.h),

                    SizedBox(height: 3.h),
                    buttonWidget(
                      "Send OTP",
                      Colors.white,
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          controller.verifyOtp(email);
                        }
                      },
                      colors: buttonColor,
                      fontFamily: 'Poppins',
                      height: 5.2.h,
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
                          text: "Didn't receive the code?  ",
                        ),
                        Obx(() => controller.isTimerRunning.value
                            ? customText(
                          color: lightTextColor.withOpacity(0.5),
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          text: "Resend in ${controller.remainingSeconds.value}s",
                        )
                            : InkWell(
                          onTap: () {
                            controller.startTimer();

                          },
                          child: customText(
                            color: buttonColor, // Active color
                            fontFamily: 'Inter',
                            fontSize: 15.sp,

                            fontWeight: FontWeight.w600,
                            text: "Resend",
                          ),
                        ),
                        ),
                      ],
                    ),
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
