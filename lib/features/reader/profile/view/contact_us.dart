import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/profile/controller/profile_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../search/widgets/header_widget.dart';
class ContactUs extends GetView<HelpAndSupportController> {
  // Controller initialize karein


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Scroll view add karein taake keyboard se error na aaye
          child: Column(
            children: [
              customHeader(context: context, title: "Contact Us", onBack: () => Get.back(), onIconPressed: () {  }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    SizedBox(height: 1.5.h),
                    emailTextFeild('Name', "John Smith", controller: controller.nameController),
                    SizedBox(height: 1.5.h),
                    emailTextFeild('Email', "jhonsmith@gmail.com", controller: controller.emailController),
                    SizedBox(height: 1.5.h),

                    // ContactUs screen mein:
                    emailTextFeild('Subject', "Enter subject", controller: controller.subjectController),
                    SizedBox(height: 1.5.h),
                    emailTextFeild(
                        'Message',
                        "Write your message here.",
                        controller: controller.messageController, // Ye add karein
                        maxLines: 5
                    ),

                    SizedBox(height: 6.h),
                    Obx(() => buttonWidget(
                      controller.isLoading.value ? "Sending..." : "Send Message",
                      whiteColor,
                      onTap: controller.isLoading.value
                          ? () {}
                          : () => controller.sendContactForm(),
                      colors: buttonColor,
                      // ... baki properties
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}