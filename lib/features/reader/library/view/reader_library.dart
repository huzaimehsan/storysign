import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';


import '../../search/widgets/header_widget.dart';
import '../controller/library_controller.dart';
import '../model/library_model.dart';

class ReaderLibrary extends GetView<ReaderController> {
  const ReaderLibrary({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(right: 3.w, left: 3.w),
              child: Row(
                children: [
                  ...["All", "Signed", "Unsigned"].asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String tab = entry.value;
                    final int flexValue = index == 0 ? 2 : 3;

                    return Expanded(
                      flex: flexValue,
                      child: Obx(() {
                        final bool isSelected = controller.selectedTab.value == tab;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
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
                  buildFilterDropdown(context),
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
                    onTap: () => {Get.toNamed("/uploadbook")},
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
              child: RefreshIndicator(
                onRefresh: () => controller.refreshRequests(),
                backgroundColor: containerColor,
                color: white,
                child: Obx(() {
                  if (controller.isLibrary.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 12.h),
                      children: [
                        SizedBox(height: 60.h),
                        Center(
                          child: customText(
                            text: controller.errorMessage.value,
                            color: greyColor,
                            fontSize: 15.sp,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }

                  final List<BookItem> books = controller.filteredBooksRx.value;
                  if (books.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 12.h),
                      children: [
                        SizedBox(height: 25.h),
                        Center(
                          child: customText(
                            text: "No books found",
                            color: greyColor,
                            fontSize: 15.sp,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount:
                    books.length + (controller.isLoadingMore.value ? 1 : 0),
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
                      final DateTime dateTime = DateTime.parse(book.uploadDate);
                      final formattedDate =
                          "Joined: ${DateFormat('dd MMMM, yyyy').format(dateTime)}";

                      return recentlySignedBooks(
                        imagePath: book.coverImage,
                        signed: book.status,
                        bookTitle: book.title,
                        authorName: book.author?.fullName ?? "No Author Selected",
                        date: formattedDate,
                        status: book.status,
                        showArrow: true,
                        trackRequest: () {
                          Get.toNamed(
                            "/requestautographcard",
                            arguments: {
                              'role': 'fromLibrary',
                              'bookId': book.id.toString(),
                              'bookTitle': book.title,
                              'coverImage': book.coverImage,
                              'authorName': book.author?.fullName ?? "",
                              'status': book.status,
                              'feeAmount': book.feeAmount,
                              'isPaid': book.isPaid,
                            },
                          );
                        },
                        showAuthor: true,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),


    );
  }

  Widget buildFilterDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      color: white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.sp),
      ),
      offset: Offset(0, 5.h),
      onSelected: (value) {
        if (value == "Reset") {
          controller.sortBy.value = "None";
          controller.fetchBooksData(status: 'all');
        } else if (value.startsWith("sort:")) {
          controller.sortBy.value = value.replaceFirst("sort:", "");
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            child: customText(
              text: "Sort By",
              color: secondryColor,
              fontSize: 13.sp,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
          ..._sortOptions.map((label) => _buildMenuItem("sort:$label", label, controller.sortBy.value)),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: "Reset",
            child: customText(
              text: "Reset",
              color: greyColor,
              fontSize: 14.sp,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
        ];
      },
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
    );
  }

  static const List<String> _sortOptions = [
    "None",
    "Title A-Z",
    "Title Z-A",
    "Date Newest",
    "Date Oldest",
  ];

  PopupMenuItem<String> _buildMenuItem(String value, String label, String currentValue) {
    final isSelected = currentValue == label;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            text: label,
            color: isSelected ? buttonColor : secondryColor,
            fontSize: 14.sp,
            fontFamily: "Poppins",
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          if (isSelected) Icon(Icons.check, size: 16.sp, color: buttonColor),
        ],
      ),
    );
  }

}
