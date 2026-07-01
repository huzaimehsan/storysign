import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';

import '../../Home/widgets/reader/user_profile_card.dart';
import '../../search/widgets/header_widget.dart';
import '../widget/profile_header_card.dart';
import '../widget/library_stat_card.dart';
import '../widget/recent_signed_book_card.dart';
import '../widget/download_history_card.dart';
import '../widget/settings_option_tile.dart';
import '../widget/settings_group_card.dart';
import '../widget/section_header.dart';
import '../../../../widgets/customText_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: containerColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Profile",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  profileHeaderCard(
                    imagePath: 'assets/png/searchprofile.png',
                    name: 'John Smith',
                    email: 'johnsmith@gmail.com',
                    joinedDate: '22 june, 2026',
                    onEdit: () {

                      Get.toNamed("/editprofile");
                    },
                  ),

                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: customText(
                      fontFamily: 'Poppins',
                      text: 'Library',
                      color: whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      libraryStatCard(
                        title: 'Total Books',
                        value: '18',
                        subtitle: '',
                      ),
                      libraryStatCard(
                        title: 'Signed Books',
                        value: '10',
                        subtitle: '',
                      ),
                      libraryStatCard(
                        title: 'Sign Rejected',
                        value: '08',
                        subtitle: '',
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  sectionHeader(
                    title: 'Recently Signed Books',
                    onSeeAll: () {},
                  ),

                  recentSignedBookCard(
                    title: 'Things Fall Apart',
                    price: '\u0024 10.00',
                    date: '22 june, 2026',
                    status: 'Completed',
                  ),
                  recentSignedBookCard(
                    title: 'God of Small Things',
                    price: '\u0024 10.00',
                    date: '22 june, 2026',
                    status: 'Completed',
                  ),
                  recentSignedBookCard(
                    title: 'Pride and Prejudice',
                    price: '\u0024 10.00',
                    date: '22 june, 2026',
                    status: 'Completed',
                  ),
                  SizedBox(height: 1.h),
                  sectionHeader(title: 'Download History', onSeeAll: () {}),

                  downloadHistoryCard(
                    imagePath: 'assets/png/book.png',
                    title: 'God of small Things',
                    author: 'Chinua Achebe',
                    date: '22 june, 2026',
                  ),
                  downloadHistoryCard(
                    imagePath: 'assets/png/book.png',
                    title: 'Things Fall Apart',
                    author: 'Chinua Achebe',
                    date: '22 june, 2026',
                  ),
                  SizedBox(height: 1.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: customText(
                      text: "Settings",
                      fontSize: 16.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  settingsGroupCard(),
                  SizedBox(height: 2.h),
                  settingsSignoutCard(),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
