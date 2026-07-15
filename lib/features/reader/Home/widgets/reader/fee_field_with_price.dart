import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/custom_text_feild.dart';

class FeeFieldWithPrice extends StatefulWidget {
  final String label;
  final String price;
  final String amount;
  final TextEditingController? controller;
  final bool? isPaid;

  const FeeFieldWithPrice({
    super.key,
    required this.label,
    required this.price,
    this.controller,
    this.isPaid = false, required this.amount,
  });

  @override
  State<FeeFieldWithPrice> createState() => _FeeFieldWithPriceState();
}

class _FeeFieldWithPriceState extends State<FeeFieldWithPrice> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
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
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.2.h,
            ),
            decoration: BoxDecoration(
              color: textFeildContainColor,
              border: Border.all(
                color: borderGreyColor,
                width: 0.15.h,
              ),
              borderRadius: BorderRadius.circular(24.sp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.isPaid == true)
            customText(
            fontFamily: "Poppins",
            text: "Paid",
            color: greenColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ) else
                customText(
                  fontFamily: "Poppins",
                  text: widget.price,
                  color: textFeildColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),

                  customText(
                    fontFamily: "Poppins",
                    text: widget.amount,
                    color: buttonColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
