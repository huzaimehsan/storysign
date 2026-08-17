import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:storysign/constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';


class FileUploadWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final File? file;
  final VoidCallback? onRemove;

  const FileUploadWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.file,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top preview area
          if (file != null)
            Column(
              children: [
                if (file!.path.endsWith('.png') || file!.path.endsWith('.jpg') || file!.path.endsWith('.jpeg'))
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.sp),
                    child: Container(
                      width: double.infinity,
                      height: 20.h,
                      color: greyColor.withOpacity(0.1),
                      child: Image.file(
                        file!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else if (file!.path.endsWith('.pdf'))
                  Container(
                    width: double.infinity,
                    height: 20.h,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.sp),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 14.w, color: Colors.redAccent),
                        SizedBox(height: 1.h),
                        customText(
                          text: file!.path.split('/').last,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent.shade700,
                          fontFamily: 'Poppins',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 20.h,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.sp),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_drive_file, size: 14.w, color: Colors.blueGrey),
                        SizedBox(height: 1.h),
                        customText(
                          text: file!.path.split('/').last,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                          fontFamily: 'Poppins',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 1.h),
              ],
            )
          else ...[

            Image.asset(
              "assets/icon/uploadimg.png",
              fit: BoxFit.cover,
              height: 10.w,
              width: 10.w,
            ),
            SizedBox(height: 1.h),

            // Default title/description when no file
            customText(
              text: title,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: secondryColor,
              fontFamily: "Poppins",
            ),
            SizedBox(height: 0.5.h),

            customText(
              text: description,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textFeildColor,
              fontFamily: "Poppins",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonWidget(
                onTap: onTap,
                "${file != null ? 'Change' : 'Choose'} File",
                whiteColor,
                fontFamily: 'Poppins',
                colors: buttonColor,
                height: 4.h,
                width: 30.w,
                fontsize: 14.2.sp,
                fontweight: FontWeight.w600,
              ),

              // no remove button or filename display — only preview + choose/change
            ],
          ),
        ],
      ),
    );
  }
}