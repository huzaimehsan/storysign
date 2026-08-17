import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/button_widget.dart';
import 'package:storysign/widgets/customText_widget.dart';
import 'package:storysign/widgets/subscription_header_widget.dart';

import '../../../../core/services/request_service.dart';
import '../controller/place_signature_controller.dart';
import '../controller/add_message_controller.dart';
import '../controller/final_review_controller.dart';
import '../widgets/ready_to_send_card.dart';
import '../widgets/signature_detail_card.dart';

class FinalReviewScreen extends GetView<FinalReviewController> {
  const FinalReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceSignatureController>();
    final messageCtrl = Get.find<AddMessageController>();
    final reqService = RequestService.find;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customHeaderAuthor(
                context: context,
                title: 'Final Review',
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Get.back();
                  }
                },
                onIconPressed: () {},
              ),
            ),

            // ── Section 1: Ready to Send ──
            SizedBox(height: 3.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: 'Ready to Send',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      color: whiteColor,
                      fontFamily: 'Poppins',
                    ),
                    SizedBox(height: 1.h),
                    ReadyToSendCard(
                      readerName: reqService.readerName.isNotEmpty
                          ? reqService.readerName
                          : '',
                      readerImagePath: reqService.readerImagePath.isNotEmpty
                          ? reqService.readerImagePath
                          : '',
                      ebookTitle: reqService.bookTitle.isNotEmpty
                          ? reqService.bookTitle
                          : 'Things Fall Apart',
                      bookImagePath: reqService.coverImage.isNotEmpty
                          ? reqService.coverImage
                          : 'assets/png/book.png',
                    ),

                    SizedBox(height: 2.5.h),

                    // ── Section 2: Ebook Detail ──
                    customText(
                      text: 'Ebook Detail',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                      letterSpacing: 0,
                      fontFamily: 'Poppins',
                    ),
                    SizedBox(height: 1.h),

                    SignatureDetailCard(
                      currentPage: placeCtrl.currentPage,
                      signatureBytes: placeCtrl.signatureBytes,
                    ),
                    SizedBox(height: 2.h),

                    // ── Section 3: Message ──
                    customText(
                      text: 'Message',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                      fontFamily: 'Poppins',
                    ),
                    SizedBox(height: 1.h),

                    // Message card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            text: messageCtrl.messageController.text,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: textFeildColor,
                            height: 1.5,
                          ),
                          SizedBox(height: 1.5.h),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Obx(
                              () => customText(
                                text:
                                    '${messageCtrl.charCount.value} Characters',
                                fontSize: 11.6.sp,
                                fontWeight: FontWeight.w500,
                                color: buttonColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // ── Button 1: Approve and Send ──
                    buttonWidget(
                      "Approve and Send",
                      whiteColor,
                      colors: buttonColor,
                      onTap: () => controller.approveAndSend(context),
                      fontFamily: 'Poppins',
                      height: 5.5.h,
                      width: double.infinity,
                      fontsize: 16.sp,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: 1.8.h),

                    // ── Button 2: Make Changes ──
                    buttonWidget(
                      "Make Changes",
                      whiteColor,
                      colors: greyColor,
                      fontFamily: 'Poppins',
                      onTap: () {
                        Navigator.of(context).pushNamed('/drawSignature');
                      },
                      height: 5.5.h,
                      width: double.infinity,
                      fontsize: 16.sp,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: 3.h),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
