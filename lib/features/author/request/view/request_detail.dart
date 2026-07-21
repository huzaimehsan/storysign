import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/request/controller/request_detail_controller.dart';
import 'package:storysign/features/author/request/widget/all_pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../../../widgets/sucess_widget.dart';

class RequestDetailAuthor extends GetView<RequestDetailController> {
  const RequestDetailAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from ModalRoute when using Navigator.pushNamed()
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String from = args?['from'] ?? '';
    final String id = args?['autographRequestId'] ?? '';

    print("RECEIVED ARGS - From: $from, ID: $id");

    // Initialize controller with data
    controller.initData(from, id);

    final bool isFromDelivered = from == 'all_delivered';
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customHeaderAuthor(
                    context: context,
                    title: 'Request Detail',
                    onBack: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Get.back();
                      }
                    },
                    onIconPressed: () {},
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    height: 1.0, // 100% of 16px
                    letterSpacing: 0.0,
                    text: "Reader",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),

            Obx(() {
              if (controller.isFetchDetailLoading.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const CircularProgressIndicator(color: buttonColor),
                  ),
                );
              }
              final requestDetail = controller.selectedRequestDetail.value;
              if (requestDetail == null) {
                return Center(
                  child: customText(
                    text: "No request details found",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
                );
              }
              return AllPendingRequest(
                imagePath: requestDetail.reader.profilePicture,
                authorName: requestDetail.reader.fullName,
                bookName: requestDetail.bookTitle,
                date: requestDetail.requestDate,
                ontap: () {},
              );
            }),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                text: "Ebook Detail",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: whiteColor,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 0.5.h),
            Obx(() {
              if (controller.isFetchDetailLoading.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const CircularProgressIndicator(color: buttonColor),
                  ),
                );
                ;
              }
              final bookDetail = controller.selectedRequestDetail.value;
              if (bookDetail == null) {
                return const SizedBox.shrink();
              }
              return eBookDetail(
                imagePath: bookDetail.coverImage,
                bookName: bookDetail.bookTitle,
                authorName: bookDetail.author.fullName,
              );
            }),
            SizedBox(height: 2.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                height: 1.0, // 100% of 16px
                letterSpacing: 0.0,
                text: "Personal Message",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: whiteColor,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 2.h),
            Obx(() {
              if (controller.isFetchDetailLoading.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const CircularProgressIndicator(color: buttonColor),
                  ),
                );
              }
              final message = controller.selectedRequestDetail.value;
              if (message == null) {
                return const SizedBox.shrink();
              }
              return signedCopyMessageCard(
                message: message.personalMessage,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              );
            }),

            if (!isFromDelivered)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    SizedBox(height: 18.h),
                    buttonWidget(
                      "Accept Request",
                      whiteColor,
                      onTap: () => Navigator.of(context).pushNamed(
                        '/pdfReview',
                        arguments: {'autographRequestId': id},
                      ),
                      colors: buttonColor,
                      fontFamily: 'Poppins',
                      height: 5.2.h,
                      width: double.infinity,
                      fontsize: 16.sp,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: 2.h),
                    buttonWidget(
                      "Decline Request",
                      whiteColor,
                      onTap: () {
                        showDeclineDialog(
                          context,
                          desc:
                              "Are you sure you want to decline this request?",
                          buttonText: "Confirm",
                          ontap: () {
                            Get.back();
                            controller.rejectRequest(context);
                          },
                        );
                      },
                      colors: greyColor,
                      fontFamily: 'Poppins',
                      height: 5.2.h,
                      width: double.infinity,
                      fontsize: 16.sp,
                      fontweight: FontWeight.w600,
                    ),
                  ],
                ),
              ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
