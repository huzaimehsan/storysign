import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/widgets/background_image.dart';
import '../../../constants/color_constants.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/customText_widget.dart';

class ChooseRole extends StatelessWidget {
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
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: SingleChildScrollView(
                child: Column(
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
                    RoleOptionCard(
                      title: "Reader",
                      description:
                          "A Reader request for signatures from authors on ebooks.",
                      iconPath: "assets/icon/reader.png",
                      isSelected: true,
                    ),
                    SizedBox(height: 3.h),

                    // Author Option
                    RoleOptionCard(
                      title: "Author",

                      description:
                          "A Reader request for signatures from authors on ebooks.",
                      iconPath: "assets/icon/author.png",
                      isSelected: false,
                    ),

                    SizedBox(height: 3.h),
                    buttonWidget(
                      "Send OTP",
                      Colors.white,
                      onTap: () => Get.toNamed('/signin'),
                      colors: buttonColor,
                      fontFamily: 'Poppins',
                      height: 5.2.h,
                      width: double.infinity,
                      fontsize: 16.sp,
                      fontweight: FontWeight.w600,
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

// Reusable Widget Class
class RoleOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final bool isSelected;

  const RoleOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        color: isSelected ? buttonColor : white,
      ),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(iconPath, width: 12.w),
            customText(
              color: isSelected ? white : buttonColor,
              fontFamily: 'Poppins',
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              text: title,
            ),
            customText(
              color: isSelected ? white.withOpacity(0.8) : buttonColor,
              fontFamily: 'Poppins',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              text: description,
            ),
          ],
        ),
      ),
    );
  }
}
