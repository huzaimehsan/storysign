import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/book_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';
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

            searchWidget(
              controller: controller.searchController,
              onChanged: (value) => controller.searchQuery.value = value,
              hintText: 'Search requests',
            ),
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.only(right: 5.w, left: 3.w),
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
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: buttonWidget(
                            tab,
                            isSelected ? whiteColor : buttonColor,
                            onTap: () => controller.selectTab(tab),
                            colors: isSelected
                                ? buttonColor
                                : const Color(0xFFF5E6D3),

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
                  GestureDetector(
                    onTap: () => _showFilterBottomSheet(context),
                    child: Container(
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),

            Expanded(
              child: Obx(() {
                final books = controller.filteredRecentlySignedBooks;
                if (books.isEmpty) {
                  return Center(
                    child: customText(
                      text: "No Tracking Request",
                      color: greyColor,
                      fontSize: 15.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 2.h),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return recentlySignedBooks(
                      imagePath: book["imagePath"] ?? "",
                      bookTitle: book["bookTitle"] ?? "",
                      authorName: book["authorName"] ?? "",
                      date: book["date"] ?? "",
                      trackRequest: () {},
                      status: book["status"] ?? "",
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 7.h),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.sp),
            topRight: Radius.circular(20.sp),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  text: "Filter Requests",
                  color: buttonColor,
                  fontSize: 18.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                ),
                GestureDetector(
                  onTap: () {
                    controller.resetFilter();
                    Get.back();
                  },
                  child: customText(
                    text: "Reset",
                    color: greyColor,
                    fontSize: 14.sp,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            customText(
              text: "Status",
              color: secondryColor,
              fontSize: 15.sp,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 1.5.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildFilterChip("All"),
                _buildFilterChip("In Process"),
                _buildFilterChip("Delivered"),

                _buildFilterChip("Signed"),

                _buildFilterChip("Unsigned"),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = controller.selectedTab.value == label;

    return GestureDetector(
      onTap: () {
        controller.applyFilter(label);
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? buttonColor : const Color(0xFFF5E6D3),
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: customText(
          text: label,
          color: isSelected ? whiteColor : buttonColor,
          fontSize: 13.sp,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
