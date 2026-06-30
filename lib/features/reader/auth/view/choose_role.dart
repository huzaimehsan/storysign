import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:storysign/widgets/background_image.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';

import '../controller/auth_controller.dart';

class ChooseRole extends GetView<AuthController> {
  const ChooseRole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 90.w,
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.5.h),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: SingleChildScrollView(
                child: Obx(
                  () {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customText(
                          color: white,
                          fontFamily: 'Poppins',
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                          text: "Choose Role",
                        ),
                        SizedBox(height: 3.h),

                        // Reader Option
                        GestureDetector(
                          onTap: () => {
                            controller.selectedRole("Reader")
                          },
                          child: RoleOptionCard(

                            title: "Reader",
                            description: "A Reader request for signatures from authors  on ebooks. Signed ebooks will be available in  reader’s Library.",
                            iconPath: "assets/icon/reader.png",

                            isSelected: controller.selectedRole.value == "Reader" || controller.selectedRole.value == "",
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Author Option
                        GestureDetector(
                          onTap: () => {
                            controller.selectedRole("Author")
                          },
                          child: RoleOptionCard(
                            title: "Author",

                            description: "An Author provides signature services on ebooks. They choose a subscription plan, signed ebooks through the platform.",
                            iconPath: "assets/icon/author.png",
                            isSelected: controller.selectedRole.value == "Author",
                          ),
                        ),

                        SizedBox(height: 3.h),
                        buttonWidget(
                          "Continue",
                          Colors.white,
                          onTap: () => controller.proceed(),
                          colors: buttonColor,
                          fontFamily: 'Poppins',
                          height: 5.2.h,
                          width: double.infinity,
                          fontsize: 16.sp,
                          fontweight: FontWeight.w600,
                        ),
                        SizedBox(height: 2.h),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final bool isSelected ;

  const RoleOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    this.isSelected = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Animation duration
      curve: Curves.easeInOut, // Smooth transition
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        color: isSelected ? buttonColor : white,

        boxShadow: isSelected
            ? [
          BoxShadow(
            color: buttonColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(),
            child: Image.asset(
              height: 6.w,
              width: 6.w,
              iconPath,
              fit: BoxFit.contain,
              color: isSelected ? white : buttonColor,
            ),
          ),
          SizedBox(height: 1.2.h),
          customText(
            color: isSelected ? white : buttonColor,
            fontFamily: 'Poppins',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            text: title,
          ),
          SizedBox(height: 1.h),
          customText(
            color: isSelected ? white.withOpacity(0.8) : buttonColor,
            fontFamily: 'Poppins',
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            text: description,
          ),
        ],
      ),
    );
  }
}
