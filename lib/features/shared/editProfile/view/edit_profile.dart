import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:storysign/features/shared/editProfile/controller/edit_profile_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';
import '../../../author/profile/controller/profile_controller.dart';
import '../../../reader/search/widgets/header_widget.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        (ModalRoute.of(context)?.settings.arguments ?? Get.arguments)
            as Map<String, dynamic>?;
    final String role = args?['role']?.toString() ?? 'reader';

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

              // Profile Image — Obx reads profileImage & profileModel observables
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() {
                      final File? pickedImage = controller.profileImage.value;
                      final String? networkUrl =
                          controller.profileModel.value?.profilePicture
                              ?.toString();
                      final bool hasNetwork =
                          networkUrl != null && networkUrl.isNotEmpty;

                      return Container(
                        height: 30.w,
                        width: 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textFeildContainColor,
                        ),
                        child: ClipOval(
                          child: pickedImage != null
                              ? Image.file(
                                  pickedImage,
                                  fit: BoxFit.cover,
                                  width: 30.w,
                                  height: 30.w,
                                )
                              : hasNetwork
                                  ? Image.network(
                                      networkUrl!,
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
                      );
                    }),
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

              // Name, Email & Bio Fields
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
                      if (role == 'author') ...[
                        SizedBox(height: 2.h),
                        emailTextFeild(
                          'Bio',
                          'Enter your biography',
                          controller: controller.bioUpdateController,
                          validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Bio cannot be empty'
                                  : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Save Changes Button — Obx reads isLoading observable
           Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child:  buttonWidget(
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



           ) ,

            ],
          ),
        ),
      ),
    );
  }
}
