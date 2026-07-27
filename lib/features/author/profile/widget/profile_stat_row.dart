import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../constants/color_constants.dart';

class AuthorSettingsItem {
  final dynamic iconPath;
  final String title;
  final VoidCallback? onTap;

  const AuthorSettingsItem({
    required this.iconPath,
    required this.title,
    this.onTap,
  });
}

Widget authorSettingsGroupCard({
  EdgeInsetsGeometry? margin,
  List<AuthorSettingsItem>? items,
}) {
  final settingsItems = items ??
      [
        AuthorSettingsItem(
          iconPath: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => Get.toNamed('/newpass'),
        ),
        AuthorSettingsItem(
          iconPath: 'assets/png/upgrade.png',
          title: 'Upgrade Plan',
          onTap: () => Get.toNamed(
            '/plan',
            arguments: {'source': 'profile', 'planType': 'premium'},
          ),
        ),
        AuthorSettingsItem(
          iconPath: 'assets/png/security.png',
          title: 'Privacy Policy',
          onTap: () => Get.toNamed('/privacy'),
        ),
        AuthorSettingsItem(
          iconPath: 'assets/png/questionmark.png',
          title: 'Help and Support',
          onTap: () => Get.toNamed(
            '/helpandsupport',
            arguments: {'role': 'author'},
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

Widget authorSettingsSignoutCard({
  EdgeInsetsGeometry? margin,
  VoidCallback? ontap,
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

Widget _buildRowItem(dynamic iconPath, String title, VoidCallback? ontap) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 6.w),
    child: InkWell(
      onTap: ontap,
      child: Row(
        children: [
          iconPath is IconData
              ? Icon(iconPath, size: 5.5.w, color: buttonColor)
              : Image.asset(
                  iconPath,
                  height: 5.5.w,
                  width: 5.5.w,
                  fit: BoxFit.contain,
                ),
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
