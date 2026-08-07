import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/request_detail_controller.dart';
import 'package:storysign/features/reader/Home/widgets/reader/request_detail_widget.dart';
import 'package:storysign/features/reader/Home/widgets/reader/custom_text_field_with_limit.dart';
import 'package:storysign/features/reader/Home/widgets/reader/fee_field_with_price.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../../../../widgets/sucess_widget.dart'; // Aapka custom dialog
import '../../search/widgets/header_widget.dart';
import '../controller/payment_controller.dart';

class RequestDetail extends GetView<ReaderDetailController> {
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

               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   if (isLoading && data == null)
                     SizedBox(
                       height: 30.h,
                       child: Center(
                         child: CircularProgressIndicator(color: buttonColor),
                       ),
                     )
                   else if (error.isNotEmpty && data == null)
                     Padding(
                       padding: EdgeInsets.all(4.w),
                       child: Center(
                         child: Text(error, style: TextStyle(color: Colors.red)),
                       ),
                     )
                   else if (data != null) ...[
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 4.w),
                         child: customText(
                           text: "Book Detail",
                           color: whiteColor,
                           fontFamily: 'Poppins',
                           fontSize: 16.sp,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                       SizedBox(height: 0.5.h),
                       RequestDetailWidget(
                         imagePath: data.coverImage,
                         bookTitle: data.title,
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
                           fontFamily: 'Poppins',
                           fontSize: 16.sp,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                       SizedBox(height: 0.5.h),
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
                         isPaid: data.isPaid,
                       ),

                       SizedBox(height: 7.h),

                       // MAKE PAYMENT BUTTON
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 4.w),
                         child: buttonWidget(
                           data.isPaid ? "Submit Request" : "Make Payment",
                           whiteColor,
                           onTap: data.isPaid
                               ? () {

                             showSuccessDialog(
                               context,
                               width: 40.w,
                               desc:
                               "Your Autograph Request have been sent Successfully",
                               buttonText: "Back To Dashboard",
                               ontap: () => Get.offAllNamed('/bottomnav'),
                             );
                           }
                               : () async {
                             final paymentController =
                             Get.find<PaymentController>();
                             final args = Get.arguments;
                             final String? clientSecret =
                             args?['clientSecret'];
                             final String? paymentIntentId =
                             args?['paymentIntentId'];

                             if (clientSecret != null &&
                                 paymentIntentId != null) {
                               bool isPaid = await paymentController
                                   .processPayment(
                                 clientSecret: clientSecret,
                                 paymentIntentId: paymentIntentId,
                               );

                               if (isPaid) {

                                 controller
                                     .selectedRequest
                                     .value = data.copyWith(
                                   isPaid: true,
                                   status:
                                   "Paid",
                                 );
                               }
                             } else {
                               Utils.showToast(
                                 "Payment details not found.",
                                 true,
                               );
                             }
                           },
                           colors: data.isPaid ? buttonColor : buttonColor,
                           fontweight: FontWeight.w600,
                           fontFamily: 'Poppins',
                           height: 5.2.h,
                           width: double.infinity,
                           fontsize: 16.sp,
                         ),
                       ),
                       SizedBox(height: 2.h),
                     ],
                 ],
               )
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
      return DateFormat('dd MMM, yyyy').format(DateTime.parse(dateString));
    } catch (e) {
      return dateString;
    }
  }
}
