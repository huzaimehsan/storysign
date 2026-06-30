import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:storysign/widgets/search_widget.dart';

import '../../widgets/reader/build_profile_card.dart';
import '../../widgets/reader/user_profile_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
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

            searchWidget(),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: sectionHeader(title: "All Authors", onSeeAll: () {}),
              ),
              SizedBox(height: 1.h),
              SizedBox(
                height: 27.w,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemCount: 5,
                  separatorBuilder: (context, index) => SizedBox(width: 1.w),
                  itemBuilder: (context, index) {
                    return userProfileCard(
                      imagePath: "assets/png/authorimg.png",
                      name: "James Davenport",
                    );
                  },
                ),
              ),

              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: sectionHeader(
                  title: " Recently Signed Books",
                  onSeeAll: () {},
                ),
              ),

              recentlySignedBooks(
                imagePath: "assets/png/book.png",
                bookTitle: "Pride and Prejudice",
                authorName: "Jane Austen",
                date: "22 june, 2026", trackRequest: () {  }, status: 'Signed',
              ),

              recentlySignedBooks(
                imagePath: "assets/png/book.png",
                bookTitle: "The Great Gatsby",
                authorName: "F. Scott Fitzgerald",
                date: "25 june, 2026", trackRequest: () {  }, status: 'Signed',
              ),

              recentlySignedBooks(
                imagePath: "assets/png/book.png",
                bookTitle: "The Great Gatsby",
                authorName: "F. Scott Fitzgerald",
                date: "25 june, 2026", trackRequest: () {  }, status: 'Signed',
              ),

              SizedBox(height: 7.h,),
            ],
          ),
        ),
      ),
    );
  }
}
