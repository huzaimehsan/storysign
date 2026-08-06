import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/button_widget.dart';
import 'package:storysign/widgets/customText_widget.dart';
import 'package:storysign/widgets/subscription_header_widget.dart';

import '../controller/add_message_controller.dart';

class AddMessageScreen extends GetView<AddMessageController> {
  const AddMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              customHeaderAuthor(
                context: context,
                title: 'Add Message',
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 4.h),

              // "Message" Label
              customText(
                text: 'Message',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: whiteColor,
                fontFamily: 'Poppins',
                height: 1.0,               // Line height 100% (100% = 1.0)
                letterSpacing: 0.0,
              ),
              SizedBox(height: 1.h),

              // Message Input Container
              Container(
                height: 61.h,
                width: 92.w,
                decoration: BoxDecoration(
                  color: white, // warm cream background Color(0xFFFBF0E3)
                  borderRadius: BorderRadius.circular(5.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(89),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    // Text Field
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 4.w, 5.w, 8.h),
                      child: TextField(
                        controller: controller.messageController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textFeildColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    // Dynamic character counter at bottom right
                    Positioned(
                      bottom: 2.h,
                      right: 5.w,
                      child: Obx(() => customText(
                            text: '${controller.charCount.value} Characters',
                            fontSize: 11.6.sp,
                            fontWeight: FontWeight.w600,
                            color: buttonColor,
                            fontFamily: 'Poppins',
                          )),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Save Message Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: buttonWidget(
                  "Save Message",
                  whiteColor,
                  colors: buttonColor,
                  onTap: () => controller.saveMessage(context),
                  fontFamily: 'Poppins',
                  height: 5.5.h,
                  width: double.infinity,
                  fontsize: 16.sp,
                  fontweight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
