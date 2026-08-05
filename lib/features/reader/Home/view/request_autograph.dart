import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/request_autograph_controller.dart';
import 'package:storysign/features/reader/library/controller/library_detail_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../search/widgets/file_upload_widget.dart';
import 'package:storysign/widgets/image_picker.dart';
import '../../search/widgets/header_widget.dart';
import '../widgets/reader/request_detail_widget.dart';
import '../widgets/reader/fee_field_with_price.dart';
import '../widgets/reader/custom_text_field_with_limit.dart';

class RequestAutographCard extends GetView<RequestAutographController> {
  const RequestAutographCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaPickerService mediaPicker = MediaPickerService();

    final args = Get.arguments as Map<String, dynamic>?;
    final String? role = args?['role']?.toString();
    final bool isLibraryRequest = role == 'fromLibrary';

    final String receivedBookId = args?['bookId']?.toString() ?? '';
    final libraryDetailController = Get.find<ReaderLibraryDetailController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetRequestForm();
      controller.receivedBookId.value = receivedBookId;
      if (isLibraryRequest && receivedBookId.isNotEmpty) {
        libraryDetailController.fetchBookDetail(receivedBookId);
      }
    });
    final homeController = controller;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customHeader(
                context: context,
                title: "Autograph Request",
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 2.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLibraryRequest) ...[
                    Obx(() {
                      final detail = libraryDetailController.detail.value;
                      final isLoading = libraryDetailController.isLoading.value;
                      if (isLoading && detail == null) {
                        return SizedBox(
                          height: 40.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: buttonColor,
                            ),
                          ),
                        );
                      }
                      if (detail == null) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: customText(
                            text: 'No book details available',
                            color: whiteColor,
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }

                      final selectedAuthorName =
                          controller.selectedAuthorName.value.isNotEmpty
                          ? controller.selectedAuthorName.value
                          : detail.authorName.isNotEmpty
                          ? detail.authorName
                          : 'Unknown';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            imagePath: detail.coverImage,
                            bookTitle: detail.title,
                            authorName: selectedAuthorName,
                            status: detail.status,
                            showSubmittedBadge: true,
                          ),
                          SizedBox(height: 1.5.h),

                          FeeFieldWithPrice(
                            label: 'Signature Price',
                            price: detail.isPaid ? 'Paid' : 'Fee',
                            amount: '${detail.feeAmount}',
                            isPaid: detail.isPaid,
                          ),
                          SizedBox(height: 1.5.h),



                        ],
                      );
                    }),
                  ],

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),

                    child: Column(
                      children: [
                        if (!isLibraryRequest) ...[
                          emailTextFeild(
                            'Book Name',
                            "Things Fall Apart",
                            controller:
                                homeController.bookTitleControllerRequest,
                          ),
                          SizedBox(height: 1.5.h),

                          Obx(
                            () => FileUploadWidget(
                              title: 'Upload Book',
                              description: controller.bookPdfFile.value != null
                                  ? "File Selected"
                                  : 'Tap to select a pdf file',
                              file: controller.bookPdfFile.value,
                              onTap: () async {
                                final file = await mediaPicker.pickMedia(
                                  context,
                                  mode: PickMode.document,
                                );
                                if (file != null) {
                                  controller.bookPdfFile.value = file;
                                }
                              },
                              onRemove: () =>
                                  controller.bookPdfFile.value = null,
                            ),
                          ),
                          SizedBox(height: 1.5.h),

                          Obx(
                            () => FileUploadWidget(
                              title: 'Upload Cover Photo',
                              description:
                                  controller.bookCoverImage.value != null
                                  ? "Image Selected"
                                  : 'Tap to select a png format',
                              file: controller.bookCoverImage.value,
                              onTap: () async {
                                final file = await mediaPicker.pickMedia(
                                  context,
                                  mode: PickMode.image,
                                );
                                if (file != null) {
                                  controller.bookCoverImage.value = file;
                                }
                              },
                              onRemove: () =>
                                  controller.bookCoverImage.value = null,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                        ],
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        Obx(() {
                          final detail = libraryDetailController.detail.value;
                          if (!isLibraryRequest ||
                              (detail != null && !detail.isPaid)) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                emailTextFeild(
                                  'Personal Message',
                                  "Write a personal message...",
                                  maxLength: 200,
                                  maxLines: 4,
                                  controller:
                                      homeController.personalMessageController,
                                ),
                                SizedBox(height: 1.5.h),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                        SizedBox(height: 5.h),
                        Obx(() {
                          final detail = libraryDetailController.detail.value;
                          final bool isLoadingDetail =
                              isLibraryRequest &&
                              libraryDetailController.isLoading.value &&
                              detail == null;
                          final bool canShowButtons =
                              !isLibraryRequest ||
                              detail != null;
                          if (isLoadingDetail || !canShowButtons)
                            return const SizedBox.shrink();

                          final bool isPaidLibraryBook = detail?.isPaid ?? false;

                          return Column(
                            children: [
                              if (!isPaidLibraryBook) ...[
                                Obx(
                                  () => buttonWidget(
                                    controller.selectedAuthorId.value.isNotEmpty
                                        ? "Author Selected ✅"
                                        : "Select Author",
                                    whiteColor,
                                    fontFamily: 'Poppins',
                                    height: 5.2.h,
                                    width: double.infinity,
                                    fontsize: 16.sp,
                                    fontweight: FontWeight.w500,
                                    onTap: () async {
                                      final result = await Get.toNamed(
                                        "/selectauthor",
                                      );
                                      if (result != null) {
                                        if (result is Map<String, dynamic>) {
                                          controller.selectedAuthorId.value =
                                              result['id']?.toString() ?? '';
                                          controller.selectedAuthorName.value =
                                              result['name']?.toString() ?? '';
                                        } else if (result is String) {
                                          controller.selectedAuthorId.value =
                                              result;
                                        }
                                      }
                                    },
                                    colors:
                                        controller
                                            .selectedAuthorId
                                            .value
                                            .isNotEmpty
                                        ? lightTextColor
                                        : buttonColor,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                buttonWidget(
                                  "Request Autograph",
                                  whiteColor,
                                  onTap: () async {
                                    final Map<String, dynamic>? result =
                                        await controller.requestAutograph(
                                          context,
                                          controller.selectedAuthorId.value,
                                          bookId: isLibraryRequest
                                              ? receivedBookId
                                              : null,
                                        );

                                    if (result != null &&
                                        result['requestId'] != null) {
                                      Get.offAllNamed(
                                        '/request',
                                        arguments: {
                                          'autographRequestId':
                                              result['requestId'],
                                          'clientSecret': result['clientSecret'],
                                          'paymentIntentId':
                                              result['paymentIntentId'],
                                          'bookId': isLibraryRequest
                                              ? receivedBookId
                                              : null,
                                          'role': isLibraryRequest
                                              ? 'fromLibrary'
                                              : 'fromHome',
                                        },
                                      );
                                    } else {
                                      Utils.showToast(
                                        "Request failed, please try again",
                                        true,
                                      );
                                    }
                                  },
                                  colors: buttonColor,
                                  height: 5.2.h,
                                  width: double.infinity,
                                  fontsize: 16.sp,
                                  fontweight: FontWeight.w600,
                                ),
                              ] else ...[
                                buttonWidget(
                                  "Go to Library",
                                  whiteColor,
                                  onTap: () {
                                    controller.selectedAuthorId.value = '';
                                    controller.selectedAuthorName.value = '';
                                    Get.back();
                                  },
                                  colors: btnColor,
                                  height: 5.2.h,
                                  fontFamily: 'Poppins',
                                  width: double.infinity,
                                  fontsize: 16.sp,
                                  fontweight: FontWeight.w600,
                                ),
                              ],
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
