import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../reader/profile/widget/profile_header_card.dart';
import '../../../reader/profile/widget/settings_group_card.dart';
import '../../../reader/search/widgets/header_widget.dart';
import '../widget/author_biography_card.dart';
import '../widget/author_profile_stat_row.dart';

class AuthorProfileScreen extends StatelessWidget {
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Profile Header Card (reused from reader) ──
                      profileHeaderCard(
                        imagePath: 'assets/png/searchprofile.png',
                        name: 'John Smith',
                        email: 'johnsmith@gmail.com',
                        joinedDate: '22 june, 2026',
                        onEdit: () {
                          Get.toNamed('/editprofile', arguments: {'role': 'author'});
                        }

                        , author: true,
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

                      authorBiographyCard(
                        bio:
                            'Award-winning author of five literary novels exploring memory, identity, and human connection. Winner of the Booker Prize 2022. Based in Edinburgh, Scotland.',
                      ),
                      SizedBox(height: 3.h),

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
                      authorSettingsGroupCard(),
                      SizedBox(height: 2.h),

                      // Sign Out card
                      settingsSignoutCard(),
                      SizedBox(height: 12.h),
                    ],
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
