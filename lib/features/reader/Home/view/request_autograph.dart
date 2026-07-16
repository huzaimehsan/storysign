
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../search/widgets/file_upload_widget.dart';
import 'package:storysign/widgets/image_picker.dart';
import '../../search/widgets/header_widget.dart';

class RequestAutographCard extends GetView<HomeController> {
  const RequestAutographCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaPickerService mediaPicker = MediaPickerService();

    final args = Get.arguments;
    String? receivedBookId;
    String? role = args['role']; // Yahan se role get hoga

    // 2. AB FLAG BNAYEIN
    bool isLibraryRequest = (role == "fromLibrary");
    if (args != null && args is Map) {
      receivedBookId = args['bookId'];
      debugPrint("Received Book ID: $receivedBookId");
    }

    // onInit mein ya build ke shuru mein
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['bookId'] != null) {
        controller.receivedBookId.value = Get.arguments['bookId'];
      }
    });
    final homeController = controller;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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

              SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() {
                      bool isLibraryRequest = (role == "fromLibrary");

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          children: [
                            // 2. Sirf tab dikhayein agar Library request NAHI hai
                            if (!isLibraryRequest) ...[
                              emailTextFeild(
                                'Book Name',
                                "Things Fall Apart",
                                controller:
                                homeController.bookTitleControllerRequest,
                              ),
                              SizedBox(height: 1.5.h),

                              // Upload Book File
                              // FileUploadWidget ko controller.bookPdfFile.value ke saath bind rakhein
                              FileUploadWidget(
                                title: 'Upload Book',
                                description: controller.bookPdfFile.value != null ? "File Selected" : 'Tap to select a pdf file',
                                file: controller.bookPdfFile.value,
                                onTap: () async {
                                  final file = await mediaPicker.pickMedia(context, mode: PickMode.document);
                                  if (file != null) controller.bookPdfFile.value = file;
                                },
                                onRemove: () => controller.bookPdfFile.value = null,
                              ),
                              SizedBox(height: 1.5.h),

                              // Upload Cover Photo
                              FileUploadWidget(
                                title: 'Upload Cover Photo',
                                description: controller.bookCoverImage.value != null ? "Image Selected" : 'Tap to select a png format',
                                file: controller.bookCoverImage.value,
                                onTap: () async {
                                  final file = await mediaPicker.pickMedia(context, mode: PickMode.image);
                                  if (file != null) controller.bookCoverImage.value = file;
                                },
                                onRemove: () => controller.bookCoverImage.value = null,
                              ),
                              SizedBox(height: 1.5.h),
                            ],

                            // 3. Personal Message (Hamesha dikhega)
                            emailTextFeild(
                              'Personal Message',
                              "Write a personal message...",
                              maxLength: 200,
                              maxLines: 4,
                              controller:
                              homeController.personalMessageController,
                            ),
                            SizedBox(height: 5.h),

                            buttonWidget(
                              controller.selectedAuthorId.value.isNotEmpty
                                  ? "Author Selected ✅"
                                  : "Select Author",
                              whiteColor,
                              fontFamily: 'Poppins',
                              height: 5.2.h,
                              width: double.infinity,
                              fontsize: 16.sp,
                              fontweight: FontWeight.w600,
                              onTap: () async {
                                final result = await Get.toNamed(
                                  "/selectauthor",
                                );
                                if (result != null && result is String) {
                                  controller.selectedAuthorId.value = result;
                                }
                              },
                              colors:
                              controller.selectedAuthorId.value.isNotEmpty
                                  ? lightTextColor
                                  : buttonColor,
                              // ... baki properties
                            ),
                            SizedBox(height: 2.h),

                            // Submit Button
                            buttonWidget(
                              "Request Autograph",
                              whiteColor,
                              onTap: () async {
                                // Pass bookId only if it's a library request
                                final String? requestId = await controller.requestAutograph(
                                    context,
                                    controller.selectedAuthorId.value,
                                    bookId: isLibraryRequest ? receivedBookId : null
                                );

                                if (requestId != null && requestId.isNotEmpty) {
                                  Get.offNamed('/request', arguments: {
                                    'autographRequestId': requestId,
                                    'bookId': isLibraryRequest ? receivedBookId : null,
                                    'role': isLibraryRequest ? 'fromLibrary' : 'fromHome',
                                  });
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
            ],
          ),
        ),
      ),
    );
  }
}
