import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../search/widgets/header_widget.dart';
import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/custom_text_feild.dart';
import '../../../../../widgets/button_widget.dart';
import '../../widgets/reader/custom_payment_text_field.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({super.key});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  String? selectedPaymentMethod;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  final List<String> paymentMethods = ['Credit Card', 'Debit Card'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Make Payment",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
            // Payment Method Dropdown
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    fontFamily: "Poppins",
                    text: "Choose Payment Method",
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
                          child: Text(method, style: TextStyle(fontFamily: "Poppins")),
                        );
                      }).toList();
                    },

                    offset: Offset(0, 50),


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
                            fontFamily: "Poppins",
                            text: selectedPaymentMethod ?? "Choose Payment Method",
                            color: selectedPaymentMethod == null ? textFeildColor : buttonColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          Icon(
                            Icons.expand_more,
                            color: buttonColor,
                            size: 6.w, // Aapke purane dropdown wala size
                          ), // Kone wala icon
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            // Card Type Label
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                fontFamily: "Poppins",
                text: "Credit Or Debit Card",
                color: whiteColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.5.h),
            // Card Number Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomPaymentTextField(
                label: "Card Number",
                hintText: "*********",
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
            ),
            SizedBox(height: 1.5.h),
            // Expiry and CVV Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  // Expiry Date
                  Expanded(
                    child: CustomPaymentTextField(
                      label: "Expiry Date",
                      hintText: "MM/YY",
                      controller: expiryController,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  // CVV
                  Expanded(
                    child: CustomPaymentTextField(
                      label: "CVV",
                      hintText: "***",
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 13.h),
            // Confirm Payment Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: buttonWidget(
                "Confirm Payment",
                whiteColor,
                onTap: () => Get.toNamed('/finalreview'),
                colors: buttonColor,
                fontFamily: 'Poppins',
                height: 5.2.h,
                // Thoda height badhayi
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

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}
