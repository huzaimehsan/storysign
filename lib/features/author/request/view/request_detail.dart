import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/request/controller/request_detail_controller.dart';
import 'package:storysign/features/author/request/widget/all_pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../../../widgets/sucess_widget.dart';

class RequestDetailAuthor extends GetView<RequestDetailController> {
  const RequestDetailAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    // Read arguments — works with both MaterialPageRoute and GetPageRoute
    final modalArgs = ModalRoute.of(context)?.settings.arguments;
    final getArgs = Get.arguments;
    final rawArgs = (modalArgs != null) ? modalArgs : getArgs;
    final args = rawArgs is Map<String, dynamic>
        ? rawArgs
        : (rawArgs is Map ? Map<String, dynamic>.from(rawArgs) : null);

    final String from = args?['from']?.toString() ?? '';
    final String id = args?['autographRequestId']?.toString() ?? '';

    // Defer initData to AFTER build — calling it directly in build() triggers
    // Obx state changes mid-frame, causing "setState() called during build" error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initData(from, id);
    });

    final bool isFromDelivered = from == 'all_delivered';


    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // Single full page loading state
          if (controller.isFetchDetailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: buttonColor),
            );
          }

          final requestDetail = controller.selectedRequestDetail.value;
          if (requestDetail == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: customHeaderAuthor(
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
                ),
                Expanded(
                  child: Center(
                    child: customText(
                      text: "No request details found",
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: greyColor,
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
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
                      height: 1.0,
                      letterSpacing: 0.0,
                      text: "Reader",
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),    SizedBox(height: 0.5.h),

              AllPendingRequest(
                imagePath: requestDetail.reader.profilePicture,
                authorName: requestDetail.reader.fullName,
                bookName: requestDetail.bookTitle,
                date: requestDetail.requestDate,
                ontap: () {},
              ),

              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: customText(
                  text: "Ebook Detail",
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 0.5.h),

              eBookDetail(
                imagePath: requestDetail.coverImage,
                bookName: requestDetail.bookTitle,
                authorName: requestDetail.reader.fullName,
              ),

              SizedBox(height: 2.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: customText(
                  height: 1.0,
                  letterSpacing: 0.0,
                  text: "Personal Message",
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 2.h),

              signedCopyMessageCard(
                message: requestDetail.personalMessage,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),

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
                          arguments: {'autographRequestId': id ,'bookPdf' : requestDetail.bookPdfUrl},
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
                            desc: "Are you sure you want to decline this request?",
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
          );
        }),
      ),
    );
  }
}