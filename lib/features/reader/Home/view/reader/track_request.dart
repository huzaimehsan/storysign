import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/book_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../search/widgets/header_widget.dart';
import '../../../search/widgets/search_author_widget.dart';
import '../../controller/reader/home_controller.dart';
import '../../widgets/reader/user_profile_card.dart';

class TrackRequest extends GetView<HomeController> {
  const TrackRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ["All", "In Process", "Delivered"];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            customHeader(
              context: context,
              title: "All Tracking Requests",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
        
            searchWidget(),
            SizedBox(height: 1.5.h),
            Padding(
              padding:  EdgeInsets.only(right: 5.w,left: 3.w),
              child: Row(
                children: [
                  ...tabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    String tab = entry.value;
        
                    int flexValue = index == 0 ? 2 : 3;
        
                    return Expanded(
                      flex: flexValue,
                      child: Obx(() {
                        bool isSelected = controller.selectedTab.value == tab;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          ),
                          child: buttonWidget(
                            tab,
                            isSelected ? whiteColor : buttonColor,
                            onTap: () => controller.selectTab(tab),
                            colors: isSelected ? buttonColor : const Color(0xFFF5E6D3),
        
                            height: 4.5.h,
                            fontFamily: "Poppins",
                            fontsize: 14.sp,
                            fontweight: FontWeight.w600,
                          ),
                        );
                      }),
                    );
                  }),
        
        
                  SizedBox(width: 2.w),
                  Container(
                    height: 4.5.h,
                    width: 10.5.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E6D3),
                      borderRadius: BorderRadius.circular(17.sp),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: buttonColor,
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
        
            recentlySignedBooks(
              imagePath: "assets/png/book.png",
              bookTitle: "Pride and Prejudice",
              authorName: "Jane Austen",
              date: "22 june, 2026",
              trackRequest: () {}, status: 'Signed',
            ),
        
            recentlySignedBooks(
              imagePath: "assets/png/book.png",
              bookTitle: "The Great Gatsby",
              authorName: "F. Scott Fitzgerald",
              date: "25 june, 2026",
              trackRequest: () {}, status: 'In process',
            ),
        
            recentlySignedBooks(
              imagePath: "assets/png/book.png",
              bookTitle: "The Great Gatsby",
              authorName: "F. Scott Fitzgerald",
              date: "25 june, 2026",
              trackRequest: () {}, status: 'Delivered',
            ),
        
            SizedBox(height: 7.h),
          ],
        ),
      ),
    );
  }
}
