import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../search/widgets/header_widget.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: containerColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Edit Profile",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 3.h),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 30.w,
                    width: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: textFeildContainColor,
                      border: Border.all(color: whiteColor.withOpacity(0.2), width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/png/searchprofile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -1.w,
                    bottom: 2.w,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Open camera or photo picker
                      },
                      child: Image.asset(
                      "assets/png/camera.png",
                      height: 8.w,
                      width: 8.w,
                      fit: BoxFit.contain,
                    ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: emailTextFeild(
                'Name',
                'John Smith',
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: emailTextFeild(
                'Email',
                'johnsmith@gmail.com',
              ),
            ),
            SizedBox(height:11.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 4.w),
              child: buttonWidget(
                "Save Changes",
                whiteColor,
                onTap: () {
                  showSuccessDialog(context, isProfile: true,desc: "Your Profile have been updated Suscessfully");
                },
                colors: buttonColor,
                fontFamily: 'Poppins',
                height: 5.2.h,
                width: double.infinity,
                fontsize: 16.sp,
                fontweight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
