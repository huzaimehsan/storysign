import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../controller/author_bottom_nav_controller.dart';

class AuthorBottomNavLayout extends GetView<AuthorBottomNavController> {
  AuthorBottomNavLayout({super.key});

  final List<Widget> _pages = [
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _pages[controller.currentIndex.value],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
        height: 8.5.h,
        decoration: BoxDecoration(
          color: bottomNavColor,
          borderRadius: BorderRadius.circular(25.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem("assets/icon/home.png", 0),
              _buildNavItem("assets/icon/search.png", 1),
              _buildNavItem("assets/icon/library.png", 2),
              _buildNavItem("assets/icon/profile.png", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String imagePath, int index) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: SizedBox(
          width: 13.w,
          height: 13.w,
          child: Image.asset(
            imagePath,
            color: isSelected ? buttonColor : iconColor,
            fit: BoxFit.contain,
          ),
        ),
      );
    });
  }
}
