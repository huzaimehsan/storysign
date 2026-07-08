import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/custom_text_feild.dart';

class CustomPaymentTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool? obscureText;

  const CustomPaymentTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          fontFamily: "Poppins",
          text: label,
          color: whiteColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText ?? false,
          style: TextStyle(
            color: textFeildColor,
            fontSize: 14.sp,
            fontFamily: "Poppins",
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: textFeildColor,
              fontSize: 14.sp,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: textFeildContainColor,
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.sp),
              borderSide: BorderSide(
                color: borderGreyColor,
                width: 0.15.h,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.sp),
              borderSide: BorderSide(
                color: borderGreyColor,
                width: 0.2.h,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}
