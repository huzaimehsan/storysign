import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:signature/signature.dart';
import 'package:storysign/constants/color_constants.dart';

import '../../../../widgets/subscription_header_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../controller/draw_signature_controller.dart';

class DrawSignatureScreen extends GetView<DrawSignatureController> {
  const DrawSignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customHeaderAuthor(
                context: context,
                title: 'Draw Signature',
                onBack: () => Navigator.pop(context),
                onIconPressed: () {},
              ),
            ),
            SizedBox(height: 3.h),

            // Apple Pencil & Finger Toggles
            Obx(() {
              final isPencil = controller.signatureMode.value == 'pencil';
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Apple Pencil Tab
                  GestureDetector(
                    onTap: () => controller.selectMode('pencil'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: isPencil ? buttonColor : white,
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icon/apple.png",
                            height: 4.w,
                            width: 4.w,
                            color: isPencil ? whiteColor : buttonColor,
                          ),
                          SizedBox(width: 2.w),
                          customText(
                            text: 'Apple Pencil',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isPencil ? whiteColor : buttonColor,
                            fontFamily: 'Poppins',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  // Finger Tab
                  GestureDetector(
                    onTap: () => controller.selectMode('finger'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: !isPencil ? buttonColor : white,
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icon/finger.png",
                            height: 4.w,
                            width: 4.w,
                            color: isPencil ? buttonColor : whiteColor,
                          ),
                          SizedBox(width: 2.w),
                          customText(
                            text: 'Finger',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: !isPencil ? whiteColor : buttonColor,
                            fontFamily: 'Poppins',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 3.h),

            // Signature Canvas Container
            Container(
              height: 45.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: white, // warm cream background
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(color: whiteColor.withAlpha(64), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(89),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(() {
                      // Trigger rebuild when mode changes (which reconstructs the controller)
                      final _ = controller.signatureMode.value;
                      return Signature(
                        controller: controller.signatureController,
                        height: 45.h,
                        width: 90.w,
                        backgroundColor: Colors.transparent,
                      );
                    }),
                    Obx(() {
                      if (controller.isSignatureEmpty.value) {
                        return IgnorePointer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.gesture_rounded,
                                color: buttonColor.withAlpha(128),
                                size: 8.w,
                              ),
                              SizedBox(height: 1.5.h),
                              customText(
                                text:
                                    'Draw the Signature Here Use pencil or mouse',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: secondryColor.withAlpha(128),
                                fontFamily: 'Poppins',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Undo, Redo, Clear circular action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleAction(
                  icon: Icons.undo_rounded,
                  onTap: controller.undo,
                ),
                SizedBox(width: 6.w),
                _buildCircleAction(
                  icon: Icons.redo_rounded,
                  onTap: controller.redo,
                ),
                SizedBox(width: 6.w),
                _buildCircleAction(
                  icon: Icons.delete_outline_rounded,
                  onTap: controller.clear,
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Confirm Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: buttonWidget(
                "Confirm Signature",
                whiteColor,
                colors: buttonColor,
                onTap: () => controller.confirmSignature(context),
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
    );
  }

  Widget _buildCircleAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: bottomNavColor, width: 1.5),
        ),
        child: Icon(icon, color: bottomNavColor, size: 4.w),
      ),
    );
  }
}
