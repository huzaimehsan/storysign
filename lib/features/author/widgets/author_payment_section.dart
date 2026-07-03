import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/color_constants.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/customText_widget.dart';
import '../../reader/Home/widgets/reader/custom_payment_text_field.dart';

class AuthorPaymentSection extends StatefulWidget {
  const AuthorPaymentSection({super.key});

  @override
  State<AuthorPaymentSection> createState() => _AuthorPaymentSectionState();
}

class _AuthorPaymentSectionState extends State<AuthorPaymentSection> {
  String? selectedPaymentMethod;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  final List<String> paymentMethods = ['Credit Card', 'Debit Card'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          fontFamily: 'Poppins',
          text: 'Choose Payment Method',
          color: whiteColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 1.h),
        PopupMenuButton<String>(
          onSelected: (String newValue) {
            setState(() {
              selectedPaymentMethod = newValue;
            });
          },
          itemBuilder: (BuildContext context) {
            return paymentMethods.map((String method) {
              return PopupMenuItem<String>(
                value: method,
                child: Text(method, style: TextStyle(fontFamily: 'Poppins')),
              );
            }).toList();
          },
          offset: const Offset(0, 50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
            decoration: BoxDecoration(
              color: textFeildContainColor,
              border: Border.all(color: borderGreyColor, width: 0.15.h),
              borderRadius: BorderRadius.circular(24.sp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  fontFamily: 'Poppins',
                  text: selectedPaymentMethod ?? 'Choose Payment Method',
                  color: selectedPaymentMethod == null ? textFeildColor : buttonColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                Icon(Icons.expand_more, color: buttonColor, size: 6.w),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        customText(
          fontFamily: 'Poppins',
          text: 'Credit Or Debit Card',
          color: whiteColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 1.5.h),
        CustomPaymentTextField(
          label: 'Card Number',
          hintText: '*********',
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          maxLength: 16,
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              child: CustomPaymentTextField(
                label: 'Expiry Date',
                hintText: 'MM/YY',
                controller: expiryController,
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: CustomPaymentTextField(
                label: 'CVV',
                hintText: '***',
                controller: cvvController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        buttonWidget(
          'Confirm Payment',
          whiteColor,
          onTap: () => Get.toNamed('/authorbottomnav'),
          colors: buttonColor,
          fontFamily: 'Poppins',
          height: 5.2.h,
          width: double.infinity,
          fontsize: 16.sp,
          fontweight: FontWeight.w600,
        ),
      ],
    );
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}
