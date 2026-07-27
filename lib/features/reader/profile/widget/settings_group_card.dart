import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../constants/color_constants.dart';

class SettingsItem {
  final dynamic iconPath;
  final String title;
  final VoidCallback? onTap;

  const SettingsItem({
    required this.iconPath,
    required this.title,
    this.onTap,
  });
}

Widget settingsGroupCard({
  EdgeInsetsGeometry? margin,
  List<SettingsItem>? items,
}) {
  final settingsItems = items ??
      [
        SettingsItem(
          iconPath: Icons.password,
          title: 'Change Password',
          onTap: () => Get.toNamed('/newpass'),
        ),
        SettingsItem(
          iconPath: 'assets/png/security.png',
          title: 'Privacy Policy',
          onTap: () => Get.toNamed('/privacy'),
        ),
        SettingsItem(
          iconPath: 'assets/png/questionmark.png',
          title: 'Help and Support',
          onTap: () => Get.toNamed(
            '/helpandsupport',
            arguments: {'role': 'reader'},
          ),
        ),
      ];

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
      children: List.generate(settingsItems.length, (index) {
        final item = settingsItems[index];
        return Column(
          children: [
            _buildRowItem(item.iconPath, item.title, item.onTap),
            if (index < settingsItems.length - 1)
              Divider(
                thickness: 0.02.h,
                color: buttonColor,
              ),
          ],
        );
      }),
    ),
  );
}

Widget settingsSignoutCard({
  EdgeInsetsGeometry? margin,
  required VoidCallback? ontap,
  dynamic iconPath,
  String title = 'Sign Out',
}) {
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
        _buildRowItem(iconPath ?? 'assets/png/signout.png', title, ontap),
      ],
    ),
  );
}

Widget _buildRowItem(dynamic icon, String title, VoidCallback? ontap) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 6.w),
    child: InkWell(
      onTap: ontap,
      child: Row(
        children: [
          icon is String
              ? Image.asset(
                  icon,
                  height: 5.5.w,
                  width: 5.5.w,
                  fit: BoxFit.contain,
                  color: buttonColor,
                )
              : Icon(icon, size: 5.8.w, color: buttonColor),
          SizedBox(width: 4.w),
          customText(
            fontFamily: 'Poppins',
            text: title,
            color: secondryColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
          const Spacer(),
          Image.asset(
            'assets/png/forward.png',
            height: 3.6.w,
            width: 3.6.w,
            fit: BoxFit.contain,
          ),
        ],
      ),
    ),
  );
}