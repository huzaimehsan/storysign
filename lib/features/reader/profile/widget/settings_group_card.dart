import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../constants/color_constants.dart';

Widget settingsGroupCard({EdgeInsetsGeometry? margin}) {
  return Container(
    width: double.infinity,
    margin: margin ?? EdgeInsets.zero,
    padding: EdgeInsets.symmetric(vertical: 1.w),
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(18.sp),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // Item 1
        _buildRowItem(Icons.password, "Change Password", () {

          Get.toNamed("/newpass");
        }),
        Divider(
          thickness: 0.02.h, // Responsive thickness
          // Responsive vertical spacing
          color: buttonColor, // Aapka grey border color
        ),

        // Item 2
        _buildRowItem("assets/png/security.png", "Privacy Policy", () {

          Get.toNamed("/privacy");
        }),
        Divider(
          thickness: 0.02.h, // Responsive thickness
          // Responsive vertical spacing
          color: buttonColor, // Aapka grey border color
        ),

        // Item 3
        _buildRowItem("assets/png/questionmark.png", "Help and Support", () {
          Get.toNamed("/helpandsupport",

            arguments: {'role': 'reader'},
          );
        }),
      ],
    ),
  );
}

Widget settingsSignoutCard({EdgeInsetsGeometry? margin,required VoidCallback? ontap}) {
  return Container(
    width: double.infinity,
    margin: margin ?? EdgeInsets.zero,
    padding: EdgeInsets.symmetric(vertical: 2.w),
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(18.sp),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // Item 1
        _buildRowItem("assets/png/signout.png", "Sign Out", ontap),
      ],
    ),
  );
}
// Naya function:
Widget _buildRowItem(dynamic icon, String title, VoidCallback? ontap) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 6.w),
    child: Row(
      children: [
        // Check karein ke icon String hai (asset) ya IconData
        icon is String
            ? Image.asset(icon, height: 5.5.w, width: 5.5.w, fit: BoxFit.contain,color: buttonColor,)
            : Icon(icon, size: 5.8.w, color: buttonColor), // Agar IconData hai

        SizedBox(width: 4.w),
        customText(
          fontFamily: 'Poppins',
          text: title,
          color: secondryColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
        const Spacer(),
        InkWell(
          onTap: ontap,
          child: Image.asset(
            "assets/png/forward.png",
            height: 3.6.w,
            width: 3.6.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}