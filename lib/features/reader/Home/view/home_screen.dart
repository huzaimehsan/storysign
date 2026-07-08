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
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: buildProfileCard(
                name: "John Aldito",
                onTrackPressed: () {
                  Navigator.of(context).pushNamed('/trackrequest');
                },
                onAutographPressed: () {
                  Get.toNamed("/requestautographcard");
                },
                onUploadBookPressed: () {
                  Get.toNamed("/uploadbook");
                },
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
            SizedBox(height: 1.h),

            Obx(() {
              final authorsList = controller.filteredAuthors;
              if (authorsList.isEmpty) {
                return SizedBox(
                  height: 10.h,
                  child: Center(
                    child: customText(
                      text: "No Author At All",

                      color: greyColor,
                      fontSize: 15.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 27.w,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemCount: authorsList.length,
                  separatorBuilder: (context, index) => SizedBox(width: 1.w),
                  itemBuilder: (context, index) {
                    final author = authorsList[index];
                    return userProfileCard(
                      imagePath: author["imagePath"]!,
                      name: author["name"]!,
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
                        imagePath: book["imagePath"]!,
                        bookTitle: book["bookTitle"]!,
                        authorName: book["authorName"]!,
                        date: book["date"]!,
                        status: book["status"]!,
                        trackRequest: () {
                          Get.toNamed("/signedcopy");
                        },
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
