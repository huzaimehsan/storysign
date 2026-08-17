import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'button_widget.dart';
import 'customText_widget.dart';

enum PickMode { image, document, any }

class MediaPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickMedia(
    BuildContext context, {
    PickMode mode = PickMode.image,
  }) async {
    return await showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // top handle
              Container(
                height: 5,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 25),

              customText(
                text: "Choose",
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),

              const SizedBox(height: 8),

              customText(
                text: "Select an option to update your profile picture",
                color: secondryColor.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (mode == PickMode.image || mode == PickMode.any)
                    _pickerItem(
                      icon: Icons.camera_alt_rounded,
                      title: "Camera",
                      color: buttonColor.withOpacity(0.08),
                      onTap: () {
                        _pickImage(ImageSource.camera).then((file) {
                          Navigator.pop(context, file);
                        });
                      },
                    ),

                  if (mode == PickMode.image || mode == PickMode.any)
                    _pickerItem(
                      icon: Icons.photo_rounded,
                      title: "Gallery",
                      color: buttonColor.withOpacity(0.08),
                      onTap: () {
                        _pickImage(ImageSource.gallery).then((file) {
                          Navigator.pop(context, file);
                        });
                      },
                    ),

                  if (mode == PickMode.document)
                    _pickerItem(
                      icon: Icons.description_rounded,
                      title: "Files",
                      color: buttonColor.withOpacity(0.08),
                      onTap: () {
                        _pickDocument().then((file) {
                          Navigator.pop(context, file);
                        });
                      },
                    ),
                ],
              ),

              const SizedBox(height: 30),

              buttonWidget(
                "Save Changes",
                whiteColor,
                colors: buttonColor,
                fontFamily: 'Poppins',
                height: 5.2.h,
                width: double.infinity,
                fontsize: 16.sp,
                fontweight: FontWeight.w600,
                onTap: () => Get.back(),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _pickerItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 30.w,
      child: Container(
        height: 6.2.h,
        width: 30.w,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(14.sp),
          border: Border.all(color: buttonColor.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14.sp),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: buttonColor, size: 18.sp),
                  SizedBox(width: 3.w),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: customText(
                        text: title,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        color: buttonColor,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> _pickDocument() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    return result != null && result.files.single.path != null
        ? File(result.files.single.path!)
        : null;
  }
}
