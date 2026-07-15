import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../../search/widgets/file_upload_widget.dart';
import 'package:storysign/widgets/image_picker.dart';
import '../../search/widgets/header_widget.dart';

class RequestAutographCard extends GetView<HomeController> {
  const RequestAutographCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaPickerService mediaPicker = MediaPickerService();

    final homeController = controller;
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String selectedAuthorId = args['authorId'] ?? '';

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

              Obx(() {
                final bool isSelected =
                    controller.selectedAuthorId.value.isNotEmpty;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      emailTextFeild(
                        'Book Name',
                        "Things Fall Apart",
                        controller: homeController.bookTitleControllerRequest,
                      ),
                      SizedBox(height: 1.5.h),

                      FileUploadWidget(
                        title: 'Upload Book',
                        description:
                            'Tap to select a pdf file from your device',
                        file: homeController.bookPdfFile.value,
                        onTap: () async {
                          final file = await mediaPicker.pickMedia(
                            context,
                            mode: PickMode.document,
                          );
                          if (file != null) {
                            controller.bookPdfFile.value = file;
                          }
                        },
                        onRemove: () => homeController.bookPdfFile.value = null,
                      ),
                      SizedBox(height: 1.5.h),

                      FileUploadWidget(
                        title: 'Upload Cover Photo',
                        description:
                            'Tap to select a png format from your device',
                        file: homeController.bookCoverImage.value,
                        onTap: () async {
                          final file = await mediaPicker.pickMedia(
                            context,
                            mode: PickMode.image,
                          );
                          if (file != null) {
                            homeController.bookCoverImage.value = file;
                          }
                        },
                        onRemove: () =>
                            homeController.bookCoverImage.value = null,
                      ),
                      SizedBox(height: 1.5.h),

                      emailTextFeild(
                        'Personal Message',
                        "Write a personal message to the author about why this book is special to you…",
                        maxLength: 200,
                        maxLines: 4,
                        controller: homeController.personalMessageController,
                      ),
                      SizedBox(height: 5.h),

                      // Select Author Button
                      buttonWidget(
                        "Select Author",
                        whiteColor,
                        onTap: () async {
                          final result = await Get.toNamed("/selectauthor");
                          if (result != null && result is String) {
                            controller.selectedAuthorId.value = result;
                          }
                        },
                        colors: lightTextColor,
                        fontFamily: 'Poppins',
                        height: 5.2.h,
                        width: double.infinity,
                        fontsize: 16.sp,
                        fontweight: FontWeight.w600,
                      ),

                      SizedBox(height: 2.h),

// Submit Button
                      buttonWidget(
                        "Request Autograph",
                        whiteColor,
                          onTap: () async {
                            if (controller.selectedAuthorId.value.isEmpty) {
                              Get.snackbar("Error", "Please select an author first!");
                              return;
                            }

                            debugPrint("Attempting request for ID: ${controller.selectedAuthorId.value}");

                            final String? requestId = await controller.requestAutograph(
                              context,
                              controller.selectedAuthorId.value,
                            );


                            debugPrint("Request Result ID: $requestId");

                            if (requestId != null && requestId.isNotEmpty) {
                              Get.toNamed("/request", arguments: {
                                'autographRequestId': requestId,
                                'role': 'alreadySelectedAuthor',
                              });
                            } else {
                              // Agar yahan print hota hai, to matlab API se response nahi mila
                              debugPrint("Request ID is null or empty");
                            }

                          },

                        colors: buttonColor,
                        fontFamily: 'Poppins',
                        height: 5.2.h,
                        width: double.infinity,
                        fontsize: 16.sp,
                        fontweight: FontWeight.w600,
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
