import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

// Note: Dono controllers ko import kar lein
import 'package:storysign/features/reader/profile/controller/edit_profile_controller.dart';
// Apne author controller ka path yahan theek kar lein

import '../../../../constants/color_constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../../author/profile/controller/profile_controller.dart';
import '../../search/widgets/header_widget.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Arguments se role catch karein (ModalRoute fallback for nested navigators)
    final args =
        (ModalRoute.of(context)?.settings.arguments ?? Get.arguments)
            as Map<String, dynamic>?;
    final String role = args?['role']?.toString() ?? 'reader';

    // 2. Role ke mutabiq sahi controller find karein
    final dynamic controller = role == 'author'
        ? Get.find<AuthorProfileController>()
        : Get.find<EditProfileController>();

    return Scaffold(
      backgroundColor: containerColor,
      body: SafeArea(
        child: SingleChildScrollView(
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

              // Profile Image - Obx se wrap kiya
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(
                      () => Container(
                        height: 30.w,
                        width: 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textFeildContainColor,
                        ),
                        child: ClipOval(
                          child: controller.profileImage.value != null
                              ? Image.file(
                                  controller.profileImage.value!,
                                  fit: BoxFit.cover,
                                  width: 30.w,
                                  height: 30.w,
                                )
                              : (role == 'author'
                                    ? (controller
                                                  .profileModel
                                                  .value
                                                  ?.profilePicture !=
                                              null &&
                                          controller
                                              .profileModel
                                              .value!
                                              .profilePicture
                                              .toString()
                                              .isNotEmpty)
                                    : (controller
                                                  .profileModel
                                                  .value
                                                  ?.profilePicture !=
                                              null &&
                                          controller
                                              .profileModel
                                              .value!
                                              .profilePicture
                                              .toString()
                                              .isNotEmpty))
                              ? Image.network(
                                  controller.profileModel.value!.profilePicture
                                      .toString(),
                                  fit: BoxFit.cover,
                                  width: 30.w,
                                  height: 30.w,
                                  errorBuilder: (ctx, err, stack) => Icon(
                                    Icons.person_rounded,
                                    color: buttonColor.withOpacity(0.6),
                                    size: 12.w,
                                  ),
                                )
                              : Icon(
                                  Icons.person_rounded,
                                  color: buttonColor.withOpacity(0.6),
                                  size: 12.w,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -1.w,
                      bottom: 2.w,
                      child: GestureDetector(
                        onTap: () => controller.pickImage(context),
                        child: Image.asset(
                          "assets/png/camera.png",
                          height: 8.w,
                          width: 8.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Name & Email Fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      emailTextFeild(
                        'Name',
                        'John Smith',
                        controller: role == 'author'
                            ? controller.authorNameUpdateController
                            : controller.nameUpdateController,
                        validator: (value) =>
                            HelperFunction.ValidateName(value ?? ''),
                      ),
                      SizedBox(height: 2.h),
                      emailTextFeild(
                        'Email',
                        'johnsmith@gmail.com',
                        controller: role == 'author'
                            ? controller.authorEmailUpdateController
                            : controller.emailUpdateController,
                        validator: (value) =>
                            HelperFunction.emailValidate(value ?? ''),
                      ),
                    ],
                  ),
                ),
              ),

              // Agar role Author hai toh Biography field show ho gi (Editable)
              if (role == 'author')
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      SizedBox(height: 1.5.h),
                      emailTextFeild(
                        'Bio',
                        'Enter your biography',
                        controller: controller.bioUpdateController,
                        // Author controller mein yeh controller hona lazmi hai
                        validator: (value) => value == null || value.isEmpty
                            ? 'Bio cannot be empty'
                            : null,
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 11.h),

              // Save Changes Button
              Obx(() {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(color: buttonColor),
                        )
                      : buttonWidget(
                          "Save Changes",
                          onTap: () {
                            if (controller.formKey.currentState?.validate() ??
                                false) {
                              role == 'author'
                                  ? controller.updateAuthorProfileWithImage(
                                      controller.selectedImage.value,
                                    )
                                  : controller.updateProfileWithImage(
                                      controller.selectedImage.value,
                                    );
                            }
                          },
                          colors: buttonColor,
                          height: 5.2.h,
                          width: double.infinity,
                          fontFamily: 'Poppins',
                          fontsize: 16.sp,
                          whiteColor,
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
