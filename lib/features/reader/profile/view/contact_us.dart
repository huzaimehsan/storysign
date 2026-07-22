import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/profile/controller/contact_us_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../search/widgets/header_widget.dart';

class ContactUs extends GetView<ContactUsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Scroll view add karein taake keyboard se error na aaye
          child: Column(
            children: [
              customHeader(
                context: context,
                title: "Contact Us",
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 1.5.h),
                      emailTextFeild(
                        'Name',
                        "John Smith",
                        controller: controller.nameController,
                        validator: (value) =>
                            HelperFunction.ValidateName(value ?? ''),
                      ),
                      SizedBox(height: 1.5.h),
                      emailTextFeild(
                        'Email',
                        "jhonsmith@gmail.com",
                        controller: controller.emailController,
                        validator: (value) =>
                            HelperFunction.emailValidate(value ?? ''),
                      ),
                      SizedBox(height: 1.5.h),

                      // ContactUs screen mein:
                      emailTextFeild(
                        'Subject',
                        "Enter subject",
                        controller: controller.subjectController,
                        validator: (value) =>
                            HelperFunction.subjectValidate(value ?? ""),
                      ),
                      SizedBox(height: 1.5.h),
                      emailTextFeild(
                        'Message',
                        "Write your message here.",
                        controller: controller.messageController,
                        validator: (value) => HelperFunction.messageValidate(value ?? ""),
                        // Ye add karein
                        maxLines: 5,
                      ),

                      SizedBox(height: 6.h),
                      Obx(
                            () => buttonWidget(
                          controller.isLoading.value ? "Sending..." : "Send Message",
                          whiteColor,
                          onTap: controller.isLoading.value
                              ? () {} // Loading hai toh kuch na karein
                              : () {
                            // Yahan check karein agar form validate ho raha hai
                            if (controller.formKey.currentState?.validate() ?? false) {
                              controller.sendContactForm();
                            }
                          },
                          colors: buttonColor,
                          height: 5.2.h,
                          width: double.infinity,
                              fontsize: 16.sp,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
