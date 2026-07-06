import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';


import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';

import '../../../../widgets/image_picker.dart';
import '../../../../widgets/sucess_widget.dart';
import '../widgets/author_detail_widget.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/header_widget.dart';

class RequestAutograph extends StatefulWidget {
  const RequestAutograph({super.key});

  @override
  State<RequestAutograph> createState() => _RequestAutographState();
}

class _RequestAutographState extends State<RequestAutograph> {
  final MediaPickerService _mediaPicker = MediaPickerService();

  File? _bookFile;

  File? _coverImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
              AuthorInfoCard(
                imagePath: "assets/png/searchprofile.png",
                bookTitle: "Matt Haig",
                date: "Joined: 22 june, 2026",
              ),
          
              SizedBox(height: 2.h),
          
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    emailTextFeild('Book Name', "Things Fall Apart"),
                    SizedBox(height: 1.5.h),
          
                    FileUploadWidget(
                      title: 'Upload Book',
                      description: 'Tap to select a pdf file from your device',
                      file: _bookFile,
                      onTap: () async {
                        final File? file = await _mediaPicker.pickMedia(context, mode: PickMode.document);
                        if (file != null) {
                          setState(() => _bookFile = file);
                        }
                      },
                      onRemove: () => setState(() => _bookFile = null),
                    ),
                    SizedBox(height: 1.5.h),
          
                    FileUploadWidget(
                      title: 'Upload Cover Photo',
                      description: 'Tap to select a png format from your device',
                      file: _coverImage,
                      onTap: () async {
                        final File? file = await _mediaPicker.pickMedia(context, mode: PickMode.image);
                        if (file != null) {
                          setState(() => _coverImage = file);
                        }
                      },
                      onRemove: () => setState(() => _coverImage = null),
                    ),
          
                    SizedBox(height: 1.5.h),
                    emailTextFeild(
                      'Personal Message',
                      "Write a personal message to the author about why this book is special to you…",
                      maxLength: 200,
                      maxLines: 4,
                    ),
                    SizedBox(height: 3.h),
          
                    buttonWidget(
                      "Request Autograph",
                      whiteColor,
                      onTap: () {

                        showSuccessDialog(
                          context,
                          desc: "Autograph request has been sent to the author",
                          buttonText: "Okay",
                          ontap: () {
                            // Your logic here
                            Get.back();
                            Get.toNamed("/bottomnav");
                          },
                        );
                      },
                      colors: buttonColor,
                      fontFamily: 'Poppins',
                      height: 5.2.h,
                      // Thoda height badhayi
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
      ),
    );
  }
}
