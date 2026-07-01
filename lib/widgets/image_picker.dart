import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import 'button_widget.dart';

class MediaPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickMedia(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
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

              const Text(
                "Choose Photo",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Select an option to update your profile picture",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  _pickerItem(
                    icon: Icons.camera_alt_rounded,
                    title: "Camera",
                    color: const Color(0xff4F46E5),
                    onTap: () {
                      _pickImage(ImageSource.camera).then((file){
                        Navigator.pop(context,file);
                      });
                    },
                  ),


                  _pickerItem(
                    icon: Icons.photo_rounded,
                    title: "Gallery",
                    color: const Color(0xff10B981),
                    onTap: () {
                      _pickImage(ImageSource.gallery).then((file){
                        Navigator.pop(context,file);
                      });
                    },
                  ),


                  _pickerItem(
                    icon: Icons.description_rounded,
                    title: "Files",
                    color: const Color(0xffF59E0B),
                    onTap: () {
                      _pickDocument().then((file){
                        Navigator.pop(context,file);
                      });
                    },
                  ),

                ],
              ),


              const SizedBox(height: 30),


              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: buttonWidget(
                  "Save Changes",
                  whiteColor,

                  colors: buttonColor,
                  fontFamily: 'Poppins',
                  height: 5.2.h,
                  width: double.infinity,
                  fontsize: 16.sp,
                  fontweight: FontWeight.w600,
                )
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

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              icon,
              size: 38,
              color: color,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
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