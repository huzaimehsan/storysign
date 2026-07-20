import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/binding/upload_book_binding.dart';
import 'package:storysign/features/reader/Home/controller/upload_book_controller.dart';
import 'package:storysign/widgets/sucess_widget.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';
import '../../search/widgets/file_upload_widget.dart';
import '../../search/widgets/header_widget.dart';
import '../controller/home_controller.dart';

class UploadBook extends GetView<UploadBookController> {
  UploadBook({super.key});

  final MediaPickerService _mediaPicker = MediaPickerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Upload Book",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  emailTextFeild(
                    'Book Name',
                    "Things Fall Apart",
                    controller: controller.bookTitleController,
                  ),
                  SizedBox(height: 1.5.h),

                  Obx(() {
                    return FileUploadWidget(
                      title: 'Upload Book',
                      description: 'Tap to select a pdf file from your device',
                      file: controller.bookPdfFile.value,
                      onTap: () async {
                        final File? file = await _mediaPicker.pickMedia(context, mode: PickMode.document);
                        if (file != null) {
                          controller.bookPdfFile.value = file;
                        }
                      },
                      onRemove: () => controller.bookPdfFile.value = null,
                    );
                  }),
                  SizedBox(height: 1.5.h),

                  Obx(() {
                    return FileUploadWidget(
                      title: 'Upload Cover Photo',
                      description: 'Tap to select a png format from your device',
                      file: controller.bookCoverImage.value,
                      onTap: () async {
                        final File? file = await _mediaPicker.pickMedia(context, mode: PickMode.image);
                        if (file != null) {
                          controller.bookCoverImage.value = file;
                        }
                      },
                      onRemove: () => controller.bookCoverImage.value = null,
                    );
                  }),

                  SizedBox(height: 8.h),

                  buttonWidget(
                    "Save Book",
                    whiteColor,
                    onTap: () {
                      controller.uploadBook(context);
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
          ],
        ),
      ),
    );
  }
}
