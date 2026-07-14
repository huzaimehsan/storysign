import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';
import 'package:storysign/features/reader/search/controller/search_page_controller.dart';

import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/header_widget.dart';

class RequestAutograph extends GetView<HomeController> {
  const RequestAutograph({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaPickerService mediaPicker = MediaPickerService();
    final String authorId = Get.arguments?['authorId'] ?? '';

    final searchController = Get.find<SearchPageController>();
    final author = searchController.authorDetailData.value;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Request to selected Author",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AuthorInfoCard(
                      imagePath: author?.profilePicture,
                      bookTitle: author?.fullName ?? 'Author',
                      date: author?.dateJoined,
                    ),
                
                    SizedBox(height: 2.h),
                
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Obx(
                        () => Column(
                          children: [
                            emailTextFeild(
                              'Book Name',
                              "Things Fall Apart",
                              controller: controller.bookTitleControllerRequest,
                            ),
                            SizedBox(height: 1.5.h),
                
                            FileUploadWidget(
                              title: 'Upload Book',
                              description: 'Tap to select a pdf file from your device',
                              file: controller.bookPdfFile.value,
                              onTap: () async {
                                final File? file = await mediaPicker.pickMedia(context, mode: PickMode.document);
                                if (file != null) {
                                  controller.bookPdfFile.value = file;
                                }
                              },
                              onRemove: () => controller.bookPdfFile.value = null,
                            ),
                            SizedBox(height: 1.5.h),
                
                            FileUploadWidget(
                              title: 'Upload Cover Photo',
                              description: 'Tap to select a png format from your device',
                              file: controller.bookCoverImage.value,
                              onTap: () async {
                                final File? file = await mediaPicker.pickMedia(context, mode: PickMode.image);
                                if (file != null) {
                                  controller.bookCoverImage.value = file;
                                }
                              },
                              onRemove: () => controller.bookCoverImage.value = null,
                            ),
                
                            SizedBox(height: 1.5.h),
                            emailTextFeild(
                              'Personal Message',
                              "Write a personal message to the author about why this book is special to you…",
                              maxLength: 200,
                              maxLines: 4,
                              controller: controller.personalMessageController,
                            ),
                            SizedBox(height: 3.h),
                
                            buttonWidget(
                              "Request Autograph",
                              whiteColor,
                              onTap: () {
                                controller.requestAutograph(context, authorId);
                              },
                              colors: buttonColor,
                              fontFamily: 'Poppins',
                              height: 5.2.h,
                              width: double.infinity,
                              fontsize: 16.sp,
                              fontweight: FontWeight.w600,
                            ),
                
                            SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
