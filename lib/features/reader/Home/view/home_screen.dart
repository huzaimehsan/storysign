import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import 'package:storysign/widgets/search_widget.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/customText_widget.dart';

import '../controller/home_controller.dart';
import '../widgets/reader/build_profile_card.dart';
import '../widgets/reader/user_profile_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPageLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: buttonColor)),
        );
      }

      return RefreshIndicator(
        backgroundColor: containerColor,
        color: white,
        onRefresh: () => controller.refreshHomeRequests(),
        child: Scaffold(
          body: SingleChildScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h),
              child: Column(
                children: [
                  // Profile Card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Obx(() {
                      final name = controller.userName.value;
                      final role = controller.userRole.value;
                      return buildProfileCard(
                        imagePath:
                            controller.userProfile.value?.profilePicture ?? '',
                        name: name.isNotEmpty ? name : 'User',
                        role: role.isNotEmpty ? role : null,
                        onTrackPressed: () {
                          Navigator.of(context).pushNamed('/trackrequest');
                        },
                        onAutographPressed: () {
                          Get.toNamed(
                            "/requestautographcard",
                            arguments: {
                              'authorId': 'authorId',
                              'bookId': 'bookId',
                              'isFromHome': true,
                            },
                          );
                        },
                        onUploadBookPressed: () {
                          Get.toNamed("/uploadbook");
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 2.h),

                  // Search Bar
                  searchWidget(
                    controller: controller.searchController,
                    onChanged: controller.onSearchChanged,
                  ),
                  SizedBox(height: 2.h),

                  // All Authors Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: sectionHeader(title: "All Authors", onSeeAll: () {}),
                  ),
                  SizedBox(height: 2.h),

                  Obx(() {
                    final authorsList = controller.filteredAuthors;
                    if (controller.isFetchHome.value) {
                      return SizedBox(
                        height: 10.h,
                        child: const Center(
                          child: CircularProgressIndicator(color: buttonColor),
                        ),
                      );
                    }
                    if (authorsList.isEmpty) {
                      return SizedBox(
                        height: 10.h,
                        child: Center(
                          child: customText(
                            text: "No authors found",
                            color: greyColor,
                            fontSize: 15.sp,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: 23.w,
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        itemCount: authorsList.length,
                        separatorBuilder: (_, __) => SizedBox(width: 2.w),
                        itemBuilder: (context, index) {
                          final author = authorsList[index];
                          return SizedBox(
                            width: 17.w,
                            child: userProfileCard(
                              imagePath: author.profilePicture,
                              name: author.fullName,
                              ontap: () {
                                Get.toNamed(
                                  '/authordetail',
                                  arguments: {
                                    'authorId': author.id,
                                    'role': 'allAuthor',
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  SizedBox(height: 1.h),

                  // Recently Signed Books Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: sectionHeader(
                      title: "Recently Signed Books",
                      onSeeAll: () {},
                    ),
                  ),
                  SizedBox(height: 0.5.h),

                  Obx(() {
                    final books = controller.filteredBooks;
                    if (controller.isBookLoading.value) {
                      return SizedBox(
                        height: 34.h,
                        child: const Center(
                          child: CircularProgressIndicator(color: buttonColor),
                        ),
                      );
                    }
                    if (books.isEmpty) {
                      return SizedBox(
                        height: 34.h,
                        child: Center(
                          child: customText(
                            text: "No Recently Signed Books",
                            color: greyColor,
                            fontSize: 15.sp,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 5.h),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: books.length +
                          (controller.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == books.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: CircularProgressIndicator(color: buttonColor),
                            ),
                          );
                        }
                        final book = books[index];
                        return recentlySignedBooks(
                          imageUrl: book.coverImage,
                          bookTitle: book.title,
                          date: book.uploadDate.toString().split(' ')[0],
                          status: book.status,
                          authorName: book.authorName,
                          trackRequest: () {
                            Get.toNamed(
                              "/signedcopy",
                              arguments: {
                                'autographRequestId': book.autographRequestId,
                                'bookId': book.bookId,
                                'bookPdfUrl': book.signedPdfUrl,
                              },
                            );
                          },
                          imagePath: '',

                          showAuthor: true,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
