import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/features/reader/auth/controller/splash_controller.dart';
import 'package:storysign/widgets/customText_widget.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../widgets/background_image.dart';
import '../../../../widgets/button_widget.dart';


class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          BackgroundImage(),

          // 2. Bottom Half Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 45.h, // Screen height ka 50%
              decoration: const BoxDecoration(
                color: containerColor, // Aapka color code
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // Vertically center
                crossAxisAlignment: CrossAxisAlignment.center,
                // Horizontally center
                children: [
                  SizedBox(height: 3.h),
                  Image.asset("assets/icon/logo.png",height: 38.w,width: 55.w,),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: customText(
                      color: white,
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      text:
                          "Digital autographs from your favorite authors, delivered to your ebook library.",

                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  buttonWidget(

                    onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(LocalDBKeys.SPLASH, true);

                  Get.toNamed('/chooserole');

                  },

                    "Get Started",
                    Colors.white,
                    colors: buttonColor,
                    fontFamily: 'Poppins',

                    height: 5.2.h,
                    width: 45.w,
                    fontsize: 16.sp,
                    fontweight: FontWeight.w600,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 🔹 Ye line Row ke content ko center karti hai
                    children: [
                      customText(
                        color: lightTextColor,
                        fontFamily: 'Inter',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        text: "Don’t have an account?  ",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 1.w,),

                      InkWell(
                        onTap: (){

                          Get.toNamed('/chooserole');

                        },

                        child: customText(
                          color: white,
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          text: "Sign Up",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
