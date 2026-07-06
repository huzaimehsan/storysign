import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';


import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/book_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/search_widget.dart';

import '../../../Home/widgets/reader/user_profile_card.dart';
import '../../../search/widgets/header_widget.dart';
import '../../controller/reader/reader_controller.dart';

class ReaderLibrary extends GetView<ReaderController> {
  const ReaderLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ["All", "Signed", "Unsigned"];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            customHeader(
              context: context,
              title: "My Library",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
        
            searchWidget(
              onChanged: (val) {
                controller.searchQuery.value = val;
              },
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
            SizedBox(height: 2.h),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  customText(
                    color: whiteColor,
                    fontFamily: 'Poppins',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    text: "All Books",
                  ),
                  Spacer(),
                  buttonWidget(
                    "Upload Book",
                    whiteColor,
                    onTap: () => {
                      
                      Get.toNamed("/uploadbook")
                    },
                    colors: buttonColor,
                    width: 35.w,
                    height: 4.4.h,
        
                    fontFamily: "Poppins",
                    fontsize: 14.sp,
                    fontweight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
        
            Expanded(
              child: Obx(() {
                final books = controller.filteredBooks;
                if (books.isEmpty) {
                  return Center(
                    child: customText(
                      text: "No books found",
                      color: greyColor,
                      fontSize: 15.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 12.h),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return recentlySignedBooks(
                      imagePath: book["imagePath"] ?? "assets/png/book.png",
                      bookTitle: book["bookTitle"] ?? "",
                      authorName: book["authorName"] ?? "",
                      date: book["date"] ?? "",
                      status: book["status"] ?? "",
                      trackRequest: () {
                        Get.toNamed('/trackrequest');
                      },
                    );
                  },
                );
              }),
            ),
        
        
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
                  text: "Filter & Sort",
                  color: buttonColor,
                  fontSize: 18.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                ),
                GestureDetector(
                  onTap: () {
                    controller.sortBy.value = "None";
                    controller.filterStatus.value = "All";
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
            Divider(height: 3.h, color: greyColor.withOpacity(0.2)),
            
            customText(
              text: "Sort By",
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
                _buildFilterChip("None", controller.sortBy),
                _buildFilterChip("Title A-Z", controller.sortBy),
                _buildFilterChip("Title Z-A", controller.sortBy),
                _buildFilterChip("Date Newest", controller.sortBy),
                _buildFilterChip("Date Oldest", controller.sortBy),
              ],
            ),
            SizedBox(height: 3.h),

            customText(
              text: "Filter by Status",
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
                _buildFilterChip("All", controller.filterStatus),
                _buildFilterChip("Signed", controller.filterStatus),
                _buildFilterChip("In process", controller.filterStatus),
                _buildFilterChip("Delivered", controller.filterStatus),
                _buildFilterChip("Unsigned", controller.filterStatus),
              ],
            ),
            SizedBox(height: 4.h),

            SizedBox(
              width: double.infinity,
              child: buttonWidget(
                "Apply Filters",
                whiteColor,
                onTap: () => Get.back(),
                colors: buttonColor,
                height: 5.h,
                fontFamily: "Poppins",
                fontsize: 15.sp,
                fontweight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterChip(String label, RxString reactiveVar) {
    return Obx(() {
      final isSelected = reactiveVar.value == label;
      return GestureDetector(
        onTap: () {
          reactiveVar.value = label;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected ? buttonColor : const Color(0xFFF5E6D3),
            borderRadius: BorderRadius.circular(15.sp),
          ),
          child: customText(
            text: label,
            color: isSelected ? whiteColor : buttonColor,
            fontSize: 13.sp,
            fontFamily: "Poppins",
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      );
    });
  }
}
