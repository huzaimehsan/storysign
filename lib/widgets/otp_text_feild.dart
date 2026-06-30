import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart'; // Sizer import karein

import '../constants/color_constants.dart';

class CustomOtpField extends StatelessWidget {
  final int length;
  final Function(String) onCompleted;
  final TextEditingController? controller;

  const CustomOtpField({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: 10.5.w,
      height: 10.5.w,
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14.sp),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.sp,
            spreadRadius: 2.sp,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2.sp),
        ),
      ),
      onCompleted: onCompleted,
    );
  }
}