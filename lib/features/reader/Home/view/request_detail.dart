import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/request_detail_controller.dart';
import 'package:storysign/features/reader/Home/widgets/reader/request_detail_widget.dart';
import 'package:storysign/features/reader/Home/widgets/reader/custom_text_field_with_limit.dart';
import 'package:storysign/features/reader/Home/widgets/reader/fee_field_with_price.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../../search/widgets/header_widget.dart';
import '../controller/payment_controller.dart';
import 'package:http/http.dart' as http;
// ... imports ...

class RequestDetail extends GetView<AuthorDetailController> {
  const RequestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final data = controller.selectedRequest.value;
          final isLoading = controller.isloading.value;
          final error = controller.errorMessage.value;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customHeader(
                  context: context,
                  title: 'Request Detail',
                  onBack: () => Get.back(),
                  onIconPressed: () {},
                ),
                SizedBox(height: 2.h),

                // LOADING STATE
                if (isLoading && data == null)
                  SizedBox(
                    height: 30.h,
                    child: Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    ),
                  )
                // ERROR STATE
                else if (error.isNotEmpty && data == null)
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Center(
                      child: Text(error, style: TextStyle(color: Colors.red)),
                    ),
                  )
                // DATA LOADED STATE
                else if (data != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: customText(
                      text: "Book Detail",
                      color: whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  RequestDetailWidget(
                    imagePath: data.coverImage,
                    bookTitle: data.title ?? 'No Title',
                    authorName: data.author.fullName,
                    status: data.status,
                    showSubmittedBadge: true,
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: customText(
                      text: "About Author",
                      color: whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  // Author Info
                  AuthorInfoCard(
                    imagePath: data.author.profilePicture ?? "",
                    bookTitle: data.author.fullName,
                    date: _formatDate(data.author.dateJoined),
                  ),

                  SizedBox(height: 1.5.h),
                  CustomMessageDisplay(
                    label: 'Personal Message',
                    message: data.personalMessage.isNotEmpty
                        ? data.personalMessage
                        : 'No message provided.',
                  ),

                  SizedBox(height: 1.5.h),
                  FeeFieldWithPrice(
                    label: 'Signature Price',
                    price: data.isPaid ? 'Paid' : 'Fee',
                    amount: '${data.feeAmount}',
                    isPaid: true,
                  ),

                  SizedBox(height: 7.h),

                  // MAKE PAYMENT BUTTON
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Obx(() {
                      // Obx add karein taaki loading par button update ho sake
                      final controller =
                          Get.find<PaymentController>(); // Get.find use karein

                      return buttonWidget(
                        controller.isPaymentLoading.value
                            ? "Processing..."
                            : (data.isPaid ? "Already Paid" : "Make Payment"),
                        fontsize: 16.sp,
                        whiteColor,
                        onTap: isLoading
                            ? () {}
                            : () async {
                                final success = await controller
                                    .processPayment();

                                  if (success) {
                                    Get.toNamed(
                                      "/signedcopy",
                                      arguments: {
                                        'requestId': data.id,
                                        'coverImage': data.coverImage,
                                        'bookName': data.title,
                                        'authorName': data.author.fullName,
                                        'dateJoined': data.uploadDate,
                                        "status": data.status,
                                        'message': data.personalMessage,
                                      },
                                    );
                                  }
                              },
                        colors:
                            (data.isPaid || controller.isPaymentLoading.value)
                            ? Colors.grey
                            : buttonColor,
                        fontweight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        height: 5.2.h,
                      );
                    }),
                  ),
                  SizedBox(height: 2.h),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Joined recently";

    try {
      // API se aayi hui string ko DateTime mein convert karein
      DateTime dateTime = DateTime.parse(dateString);

      // Apni marzi ka format set karein (e.g., "10 Jul, 2026")
      return DateFormat('dd MMM, yyyy').format(dateTime);
    } catch (e) {
      return dateString; // Agar error aaye to original string return karein
    }
  }
}
