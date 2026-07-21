import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/profile/controller/edit_profile_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/image_picker.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../../author/profile/widget/author_biography_card.dart';
import '../../search/widgets/header_widget.dart';

class EditProfile extends GetView<EditProfileController> {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final String role = Get.arguments?['role'] ?? 'reader';
    return Scaffold(
      backgroundColor: containerColor,
      body: SafeArea(
        child: SingleChildScrollView(
          // Scrollable banayein taake keyboard se overflow na ho
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
                              : (controller.profileModel.value?.profilePicture != null &&
                                     controller.profileModel.value!.profilePicture.toString().isNotEmpty)
                                  ? Image.network(
                                      controller.profileModel.value!.profilePicture.toString(),
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
              // Fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child:
                Column(
                  children: [
                    emailTextFeild(
                      'Name',
                      'John Smith',
                      controller: controller.nameUpdateController,
                    ),

                    SizedBox(height: 2.h),

                    emailTextFeild(
                      'Email',
                      'johnsmith@gmail.com',
                      controller: controller.emailUpdateController,
                    ),
                  ],
                )

              ),


              if (role == 'author')
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.4.h,
                  ),

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
              // Save Changes button wale Obx ko aise likhein:
              Obx(() {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : buttonWidget(
                    "Save Changes",

                    onTap: () {
                      // 1. Data Map
                      Map<String, dynamic> updateData = {
                        "fullName": controller.nameUpdateController.text.trim(),
                        "email": controller.emailUpdateController.text.trim(),
                      };

                      // 2. Image File (agar user ne select ki hai)
                      File? imageFile = controller.selectedImage.value != null
                          ? File(controller.selectedImage.value!.path)
                          : null;

                      // 3. Controller function call
                      controller.updateProfileWithImage(controller.selectedImage.value);
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
