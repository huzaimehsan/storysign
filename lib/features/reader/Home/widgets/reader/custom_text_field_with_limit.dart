import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/custom_text_feild.dart';

class CustomTextFieldWithLimit extends StatefulWidget {
  final String label;
  final String hintText;
  final int maxLength;
  final int maxLines;
  final TextEditingController? controller;

  const CustomTextFieldWithLimit({
    super.key,
    required this.label,
    required this.hintText,
    this.maxLength = 200,
    this.maxLines = 4,
    this.controller,
  });

  @override
  State<CustomTextFieldWithLimit> createState() => _CustomTextFieldWithLimitState();
}

class _CustomTextFieldWithLimitState extends State<CustomTextFieldWithLimit> {
  late TextEditingController _controller;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _controller.text.length;
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_updateCharCount);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            fontFamily: "Poppins",
            text: widget.label,
            color: whiteColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 1.h),
          Stack(
            children: [
              TextField(
                controller: _controller,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 14.sp,
                  fontFamily: "Poppins",
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: textFeildColor,
                    fontSize: 13.sp,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: textFeildContainColor,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.sp),
                    borderSide: BorderSide(
                      color: borderGreyColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.sp),
                    borderSide: BorderSide(
                      color: borderGreyColor,
                      width: 0.15.h,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.sp),
                    borderSide: BorderSide(
                      color: borderGreyColor,
                      width: 0.2.h,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                  counterText: '',
                ),
              ),
              Positioned(
                right: 4.w,
                bottom: 1.2.h,
                child: customText(
                  fontFamily: "Poppins",
                  text: "${widget.maxLength} character",
                  color: buttonColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
