import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/widgets/sucess_widget.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';
import '../../search/widgets/file_upload_widget.dart';
import '../../search/widgets/header_widget.dart';

class UploadBook extends StatefulWidget {
   UploadBook({super.key});

  @override
  State<UploadBook> createState() => _UploadBookState();
}

class _UploadBookState extends State<UploadBook> {
  final MediaPickerService _mediaPicker = MediaPickerService();

  File? _bookFile;

  File? _coverImage;

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
        
                  SizedBox(height: 8.h),
        
                  buttonWidget(
                    "Save Book",
                    whiteColor,
                    onTap: (){

                      showSuccessDialog(context,desc: "Book has been uploaded",buttonText: "Okay",ontap: (){

                        Get.back();
                        Get.back();
                      });
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
    );
  }
}
