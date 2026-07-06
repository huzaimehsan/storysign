import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../../author/profile/widget/author_biography_card.dart';
import '../../search/widgets/header_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String role;

  @override
  void initState() {
    super.initState();

    var args = Get.arguments;
    role = (args != null && args['role'] != null) ? args['role'] : 'reader';
  }

  final MediaPickerService _mediaPickerService = MediaPickerService();

  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: containerColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Edit Profile",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 3.h),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 30.w,
                    width: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: textFeildContainColor,
                      border: Border.all(
                        color: whiteColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: _profileImage != null
                          ? Image.file(
                              _profileImage!,
                              fit: BoxFit.cover,
                              width: 20.w, // Container size ke mutabiq
                              height: 20.w,
                            )
                          : Container(
                              color: Colors.grey.withOpacity(0.2),
                              // Placeholder ka background color
                              child: Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  color: buttonColor.withOpacity(0.6),
                                  size: 12.w, // Size adjust karlein
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    right: -1.w,
                    bottom: 2.w,
                    child: GestureDetector(
                      onTap: () async {
                        final File? file = await _mediaPickerService.pickMedia(
                          context,
                        );

                        if (file != null) {
                          setState(() {
                            _profileImage = file;
                          });
                        }
                      },
                      child: Image.asset(
                        "assets/png/camera.png",
                        height: 8.w,
                        width: 8.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: emailTextFeild('Name', 'John Smith'),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: emailTextFeild('Email', 'johnsmith@gmail.com'),
            ),

            if (role == 'author')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: customText(
                        text: 'Biography',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    authorBiographyCard(
                      bio:
                          'Award-winning author of five literary novels exploring memory, identity, and human connection. Winner of the Booker Prize 2022. Based in Edinburgh, Scotland.',
                    ),
                  ],
                ),
              ),

            SizedBox(height: 11.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: buttonWidget(
                "Save Changes",
                whiteColor,
                onTap: () {
                  showSuccessDialog(
                    ontap: () {
                      Get.back();

                      // Route Navigation
                      if (role == "reader") {
                        Get.toNamed("/bottomnav");
                      } else {
                        Get.toNamed('/authorbottomnav');
                      }
                    },

                    context,

                    desc: "Your Profile have been updated Suscessfully",
                  );
                },
                colors: buttonColor,
                fontFamily: 'Poppins',
                height: 5.2.h,
                width: double.infinity,
                fontsize: 16.sp,
                fontweight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
