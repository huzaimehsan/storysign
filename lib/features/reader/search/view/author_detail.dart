import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../widgets/author_detail_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_author_widget.dart';

class AuthorDetail extends StatelessWidget {
  const AuthorDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Author Detail",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),

            SizedBox(height: 1.h),


            AuthorInfoCard(imagePath: "assets/png/searchprofile.png",
                bookTitle: "Matt Haig",
                date: "Joined: 22 june, 2026"),

            SizedBox(height: 1.h),
            AuthorBiographyCard(
                description: "The Austen household was lively, tight-knit, and deeply engaged in reading and amateur theatricals. Jane’s lifelong confidante and closest friend was her elder sister, Cassandra; neither sister ever married, though they had early suitors."),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: buttonWidget(
                "Request Autograph",
                whiteColor,
                onTap: () => Get.toNamed('/requestautograph'),
                colors: buttonColor,
                fontFamily: 'Poppins',
                height: 5.2.h,
                // Thoda height badhayi
                width: double.infinity,
                fontsize: 16.sp,
                fontweight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
