import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';


import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/sucess_widget.dart';

import '../../../reader/profile/widget/profile_header_card.dart';

import '../../../reader/search/widgets/header_widget.dart';
import '../controller/profile_controller.dart';
import '../widget/biography_card.dart';
import '../widget/profile_stat_row.dart';

class AuthorProfileScreen extends GetView<AuthorProfileController> {
  const AuthorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: containerColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            customHeader(
              context: context,
              title: 'Profile',
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),

            Expanded(
              child: RefreshIndicator(
                color: buttonColor,
                onRefresh:() => controller.refreshProfileRequests(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: 60.h,
                          child: const Center(
                            child: CircularProgressIndicator(color: buttonColor),
                          ),
                        );
                      }

                      if (controller.errorMessage.value.isNotEmpty) {
                        return SizedBox(
                          height: 60.h,
                          child: Center(
                            child: customText(
                              text: controller.errorMessage.value,
                              color: whiteColor,
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }

                      final profile = controller.authorProfile.value;
                      if (profile == null) {
                        return SizedBox(
                          height: 60.h,
                          child: const Center(
                            child: CircularProgressIndicator(color: buttonColor),
                          ),
                        );
                      }

                      String formattedDate = "";
                      if (profile.dateJoined != null &&
                          profile.dateJoined.toString().isNotEmpty) {
                        try {
                          formattedDate = DateFormat('dd MMM, hh:mm a').format(
                            DateTime.parse(
                              profile.dateJoined.toString(),
                            ).toLocal(),
                          );
                        } catch (e) {
                          formattedDate = profile.dateJoined.toString();
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Profile Header Card (reused from reader) ──
                          profileHeaderCard(
                            imagePath: profile.profilePicture?.toString() ?? "",
                            name: profile.fullName?.toString() ?? "No Name",
                            email: profile.email?.toString() ?? "No Email",
                            joinedDate: formattedDate,
                            onEdit: () {
                              Get.toNamed(
                                '/editprofile',
                                arguments: {'role': 'author'},
                              );
                            },
                            author: true,
                            plan: profile.activePlanName ?? "",
                            autograph:
                                profile.totalSignedAutographs.toString() ?? "",
                          ),
                          SizedBox(height: 1.5.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: customText(
                              text: 'Biography',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 1.5.h),

                          authorBiographyCard(bio: profile.bio ?? ''),
                          SizedBox(height: 2.h),

                          // ── Settings section ──
                          Align(
                            alignment: Alignment.centerLeft,
                            child: customText(
                              text: 'Settings',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 1.5.h),

                          // Settings group: Change Password, Privacy Policy, Help & Support
                          authorSettingsGroupCard(
                            items: [
                              AuthorSettingsItem(
                                iconPath: Icons.lock_outline,
                                title: 'Change Password',
                                onTap: () => Get.toNamed('/newpass'),
                              ),
                              AuthorSettingsItem(
                                iconPath: 'assets/png/upgrade.png',
                                title: 'Upgrade Plan',
                                onTap: () => Get.toNamed(
                                  '/plan',
                                  arguments: {
                                    'source': 'profile',
                                    'planType': 'premium',
                                    'planName': profile.activePlanName ?? '',
                                  },
                                ),
                              ),
                              AuthorSettingsItem(
                                iconPath: 'assets/png/security.png',
                                title: 'Privacy Policy',
                                onTap: () => Get.toNamed('/privacy'),
                              ),
                              AuthorSettingsItem(
                                iconPath: 'assets/png/questionmark.png',
                                title: 'Help and Support',
                                onTap: () => Get.toNamed(
                                  '/helpandsupport',
                                  arguments: {'role': 'author'},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Sign Out card
                          authorSettingsSignoutCard(
                            iconPath: 'assets/png/signout.png',
                            ontap: () {
                              showSuccessDialog(
                                context,
                                buttonText: 'Confirm',
                                desc: 'Are you sure you want to logout?',
                                ontap: () {
                                  controller.signOut();
                                },
                              );
                            },
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
