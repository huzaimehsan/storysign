import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';

import '../../Home/widgets/reader/user_profile_card.dart';
import '../../search/widgets/header_widget.dart';
import '../controller/library_controller.dart';
import '../model/library_model.dart';

class ReaderLibrary extends GetView<ReaderController> {
  const ReaderLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ["All", "Signed", "Unsigned"];
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.refreshRequests(),

        child: SafeArea(
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
                    buildFilterDropdown(context), // ✅ dropdown seedha yahan
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
                child: Obx(() {
                  if (controller.isLibrary.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    );
                  }

                  final List<BookItem> books = controller.filteredBooksRx.value;
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

                      final DateTime dateTime = DateTime.parse(book.uploadDate);
                      final formattedDate =
                          "Joined: ${DateFormat('dd MMMM, yyyy').format(dateTime)}";
                      final bool isOnlyFromLibrary = book.autographRequestId == null || book.autographRequestId!.isEmpty;
                      return recentlySignedBooks(
                        imagePath: book.coverImage,
                        signed: book.status,
                        bookTitle: book.title,
                        authorName: book.author?.fullName ?? "",
                        date: formattedDate,
                        status: book.status,


                        showArrow: isOnlyFromLibrary,

                        trackRequest: isOnlyFromLibrary ? () {
                          Get.toNamed(
                            "/requestautographcard",
                            arguments: {
                              'bookId': book.id.toString(),
                              'bookTitle': book.title.toString(),
                              'role': "fromLibrary",
                            },
                          );
                        } : () {},

                        showAuthor: true,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
// ✅ Dropdown menu — button ke bilkul neeche khulta hai, bottom sheet NAHI hai
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
          controller.filterStatus.value = "All";
          // Reset karne par current tab ke hisaab se re-fetch
          controller.selectTab(controller.selectedTab.value);
        } else if (value.startsWith("sort:")) {
          controller.sortBy.value = value.replaceFirst("sort:", "");
        } else if (value.startsWith("status:")) {
          final selectedStatus = value.replaceFirst("status:", "");
          controller.filterStatus.value = selectedStatus;
          // Status filter ke liye All tab pe switch karo taake pura data ho
          if (selectedStatus != "All") {
            controller.selectedTab.value = "All";
            controller.fetchBooksData(status: 'all');
          }
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
            enabled: false,
            child: customText(
              text: "Filter by Status",
              color: secondryColor,
              fontSize: 13.sp,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
          ..._statusOptions.map((label) => _buildMenuItem("status:$label", label, controller.filterStatus.value)),
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

  static const List<String> _statusOptions = [
    "All",
    "Signed",
    "Unsigned",
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
