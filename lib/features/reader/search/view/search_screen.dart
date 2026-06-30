import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../widgets/search_widget.dart';

import '../widgets/header_widget.dart';
import '../widgets/search_author_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customHeader(
            context: context,
            title: "All Authors",
            onBack: () => Get.back(),
            onIconPressed: () {},
          ),
          SizedBox(height: 2.h),

          searchWidget(),

          SizedBox(height: 1.h),
          SearchAuthorCard(
            imagePath: "assets/png/searchprofile.png",
            bookTitle: "Matt Haig",
            date: "Joined: 22 june, 2026",
            requestAutoGraph: () {},
            authorDetail: () {
              Navigator.of(context).pushNamed('/authordetail');
            },
          ),
          SizedBox(height: 0.3.h),
          SearchAuthorCard(
            imagePath: "assets/png/searchprofile.png",
            bookTitle: "Matt Haig",
            date: "Joined: 22 june, 2026",
            requestAutoGraph: () {},
            authorDetail: () {},
          ),
          SizedBox(height: 0.3.h),
          SearchAuthorCard(
            imagePath: "assets/png/searchprofile.png",
            bookTitle: "Matt Haig",
            date: "Joined: 22 june, 2026",
            requestAutoGraph: () {},
            authorDetail: () {},
          ),
        ],
      ),
    );
  }
}
