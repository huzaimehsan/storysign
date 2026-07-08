import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../widgets/background_image.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String role = Get.arguments ?? 'reader';

  bool get isAuthor => role == 'author';
  final MediaPickerService _mediaPickerService = MediaPickerService();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final imagePath = SharedPreferencesMethod.getProfileImagePath();
      print('📂 Loading image from: $imagePath');
      
      if (imagePath != null && File(imagePath).existsSync()) {
        setState(() {
          _profileImage = File(imagePath);
        });
        print('✅ Image loaded successfully');
      } else {
        print('⚠️ Image file not found or path is null');
      }
    } catch (e) {
      print('❌ Error loading image: $e');
    }
  }

  Future<void> _saveImageToLocalStorage(File imageFile) async {
    try {
      print('📸 Picked file path: ${imageFile.path}');
      print('📸 File exists: ${imageFile.existsSync()}');
      
      final appDocDir = await getApplicationDocumentsDirectory();
      final fileName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final savePath = '${appDocDir.path}/$fileName';
      
      print('📸 Saving to: $savePath');
      
      final savedImage = await imageFile.copy(savePath);
      
      print('📸 Saved image exists: ${savedImage.existsSync()}');
      print('📸 Saved image path: ${savedImage.path}');

      await SharedPreferencesMethod.setProfileImagePath(savedImage.path);
      print('💾 Path saved to SharedPreferences');

      setState(() {
        _profileImage = savedImage;
      });
      
      print('✅ Image saved and displayed successfully!');
    } catch (e) {
      print('❌ Error saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          BackgroundImage(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                 top: 3.h,
                ),
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: 90.w,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: customText(
                          color: white,
                          fontFamily: 'Poppins',
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                          text: "Create Account",
                          height: 1.0,
                          letterSpacing: 0.0,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 25.w,
                              width: 25.w,
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
                                        width: 20.w,
                                        height: 20.w,
                                      )
                                    : Container(
                                        color: Colors.grey.withOpacity(0.2),
                                        child: Center(
                                          child: Icon(
                                            Icons.person_rounded,
                                            color: buttonColor.withOpacity(0.6),
                                            size: 12.w,
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
                                  final File? file = await _mediaPickerService
                                      .pickMedia(context);
                                  if (file != null) {
                                    await _saveImageToLocalStorage(file);
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

                      SizedBox(height: 1.5.h),

                      // Fields
                      emailTextFeild('Full Name', "Lisa Jhon"),
                      SizedBox(height: 1.5.h),
                      emailTextFeild('Email', "abc@gmail.com"),
                      SizedBox(height: 1.5.h),
                      emailTextFeild('Password', "8+ character"),
                      SizedBox(height: 1.5.h),
                      emailTextFeild('Confirm Password', "**********"),

                      if (isAuthor) ...[
                        SizedBox(height: 1.5.h),
                        emailTextFeild('Bio Graphy', "Write about yourself"),
                      ],

                      SizedBox(height: 3.h),
                      buttonWidget(
                        "Sign Up",
                        whiteColor,
                        onTap: () => isAuthor
                            ? Get.toNamed('/plan')
                            : Get.toNamed('/bottomnav'),
                        colors: buttonColor,
                        fontFamily: 'Poppins',
                        height: 5.5.h,
                        width: double.infinity,
                        fontsize: 16.sp,
                        fontweight: FontWeight.w600,
                      ),

                      SizedBox(height: 2.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText(
                            color: lightTextColor,
                            fontSize: 15.sp,
                            text: "Already have an account? ",
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/signin'),
                            child: customText(
                              color: white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              text: "Sign In",
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Divider section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.1.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: textFeildColor,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: customText(
                                text: "Continue with",
                                color: lightTextColor,
                                fontSize: 14.sp,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: textFeildColor,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Row(
                        children: [
                          Expanded(
                            child: buttonWidget(
                              "Apple",
                              whiteColor,
                              colors: buttonColor,
                              height: 5.2.h,
                              fontsize: 16.sp,
                              fontFamily: "Poppins",
                              fontweight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: buttonWidget(
                              "Google",
                              buttonColor,
                              colors: whiteColor,
                              height: 5.2.h,
                              fontsize: 16.sp,
                              fontweight: FontWeight.w600,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
