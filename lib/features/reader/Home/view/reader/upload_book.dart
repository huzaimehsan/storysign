import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/custom_text_feild.dart';
import '../../../search/widgets/file_upload_widget.dart';
import '../../../search/widgets/header_widget.dart';

class UploadBook extends StatelessWidget {
  const UploadBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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



            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  emailTextFeild('Book Name', "Things Fall Apart"),
                  SizedBox(height: 1.5.h),

                  FileUploadWidget(
                    title: 'Upload Book',
                    description: 'Tap to select a pdf file from your device',
                    onTap: () {},
                  ),
                  SizedBox(height: 1.5.h),

                  FileUploadWidget(
                    title: 'Upload Cover Photo',
                    description: 'Tap to select a png format from your device',
                    onTap: () {},
                  ),

                  SizedBox(height: 8.h),

                  buttonWidget(
                    "Save Book",
                    whiteColor,
                    onTap: () => Get.toNamed('/requestautograph'),
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
