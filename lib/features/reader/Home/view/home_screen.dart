import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:storysign/widgets/search_widget.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/local_db_key.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../controller/home_controller.dart';
import '../widgets/reader/build_profile_card.dart';
import '../widgets/reader/user_profile_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final homeController = controller;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h),
        child: Column(
          children: [
            Padding(

              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Builder(
                builder: (context) {
                  final prefs = Get.find<SharedPreferences>();
                  final userName = prefs.getString(LocalDBKeys.USERFULLNAME);
                  final userRole = prefs.getString('role');

                  print("DEBUG: All keys in Prefs: ${prefs.getKeys()}");


                  print("DEBUG NAME: $userName"); // Console mein check karein
                  print("DEBUG ROLE: $userRole");
                  return buildProfileCard(
                    name:  userName?? "User",

                    onTrackPressed: () {
                      Navigator.of(context).pushNamed('/trackrequest');
                    },
                    onAutographPressed: () {
                      // Agar aapke paas koi author ya book selected hai, toh uski ID yahan pass karein
                      Get.toNamed("/requestautographcard", arguments: {
                        'authorId': 'authorId',
                        'bookId': 'bookId',
                        'isFromHome': true,
                      });
                    },
                    onUploadBookPressed: () {
                      Get.toNamed("/uploadbook");
                    }, role: userRole,
                  );
                }
              ),
            ),
            SizedBox(height: 2.h),

            searchWidget(
              onChanged: (val) {
                controller.searchQuery.value = val;
              },
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: sectionHeader(title: "All Authors", onSeeAll: () {}),
            ),
            SizedBox(height: 2.h),

            Obx(() {
              final authorsList = homeController.welcomes;

              // 1. Loading state check
              if (controller.isFetchHome.value) {
                return SizedBox( // Yahan 'return' add karein
                  height: 20.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              // 2. Data available state
              return Container( // Yahan bhi 'return' hona chahiye
                height: 23.w,
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  itemCount: authorsList.length,
                  separatorBuilder: (context, index) => SizedBox(width: 2.w),
                  itemBuilder: (context, index) {
                    final author = authorsList[index];
                    return SizedBox(
                      width: 17.w,
                      child: userProfileCard(
                        imagePath: author.profilePicture,
                        name: author.fullName,
                        ontap: () {
                          print(author.id);
                          Get.toNamed('/authordetail', arguments: {
                            'authorId': author.id,
                            'role': 'allAuthor'
                          });
                        },


                      ),
                    );
                  },
                ),
              );
            }),

            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: sectionHeader(
                title: " Recently Signed Books",
                onSeeAll: () {},
              ),
            ),
            SizedBox(height: 0.5.h),
            Obx(() {
              final books = controller.filteredRecentlySignedBooks;
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (books.isEmpty) {
                return Expanded(
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

              return Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 5.h),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return recentlySignedBooks(
                        imageUrl: book["imagePath"]!,
                        bookTitle: book["bookTitle"]!,
                        authorName: book["authorName"]!,
                        date: book["date"]!,
                        status: book["status"]!,
                        trackRequest: () {
                          Get.toNamed("/signedcopy");
                        }, imagePath: '', showAuthor: true,
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
