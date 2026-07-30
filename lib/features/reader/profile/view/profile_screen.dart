import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/profile/controller/profile_screen_controller.dart';
import 'package:storysign/widgets/sucess_widget.dart';

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

class ProfileScreen extends GetView<ProfileScreenController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: containerColor,
      body: RefreshIndicator(
        color: buttonColor,
        onRefresh: () => controller.refreshRequests(),
        child: SafeArea(
          bottom: false,
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

              Expanded(
                child: SingleChildScrollView(
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

                    final profile = controller.profileModel.value;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        children: [
                          profileHeaderCard(
                            imagePath: profile?.profilePicture ?? "",
                            name: profile?.fullName ?? "No Name",
                            email: profile?.email ?? "No Email",
                            joinedDate: profile?.dateJoined ?? " ",
                            author: false,
                            onEdit: () {
                              Get.toNamed(
                                '/editprofile',
                                arguments: {'role': 'reader'},
                              );
                            },
                            plan: '',
                            autograph: '',
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

                          Obx(() {
                            final stats = controller.libraryStats.value;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                libraryStatCard(
                                  title: 'Total Books',
                                  value:
                                  stats?.totalUploadedBooks?.toString() ??
                                      "0",
                                  subtitle: '',
                                ),
                                libraryStatCard(
                                  title: 'Signed Books',
                                  value: stats?.signedBooks?.toString() ?? "0",
                                  subtitle: '',
                                ),
                                libraryStatCard(
                                  title: 'Sign Rejected',
                                  value: stats?.signRejected?.toString() ?? "0",
                                  subtitle: '',
                                ),
                              ],
                            );
                          }),
                          Obx(() {
                            if (controller.books.isEmpty) return const SizedBox.shrink();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 1.h),
                                sectionHeader(
                                  title: 'Recently Signed Books',
                                  onSeeAll: () {},
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.books.length,
                                  itemBuilder: (context, index) {
                                    final book = controller.books[index];
                                    return recentSignedBookCard(
                                      title: book.title ?? " ",
                                      price: '\u0024 ${book.feeAmount ?? ""}',
                                      date: book.uploadDate.toString().split(' ')[0],
                                      status: book.status,
                                    );
                                  },
                                ),
                              ],
                            );
                          }),

                          Obx(() {
                            if (controller.isbookLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(color: buttonColor),
                              );
                            }
                            if (controller.bookList.isEmpty) return const SizedBox.shrink();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 1.h),
                                sectionHeader(
                                  title: 'Download History',
                                  onSeeAll: () {},
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.bookList.length,
                                  itemBuilder: (context, index) {
                                    final book = controller.bookList[index];
                                    return downloadHistoryCard(
                                      imagePath: book.coverImage ?? "",
                                      title: book.bookTitle,
                                      date: book.createdAt.toString().split(' ')[0],
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
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
                          settingsSignoutCard(
                            ontap: () {
                              showSuccessDialog(
                                context,
                                buttonText: 'Confirm',
                                desc: "Are you sure you want to logout?",
                                ontap: () {
                                  controller.signOut();
                                },
                              );
                            },
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
