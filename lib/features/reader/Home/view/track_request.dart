import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/track_request_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../search/widgets/header_widget.dart';


class TrackRequest extends GetView<TrackRequestController> {
  const TrackRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ["All", "In Process", "Delivered"];
    return Scaffold(
      body: SafeArea(
        bottom: false,
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
                  ...tabs
                      .asMap()
                      .entries
                      .map((entry) {
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
                            onTap: () => controller.selectedTab.value = tab,
                            colors: isSelected
                                ? buttonColor
                                : const Color(0xFFF5E6D3),

                            height: 4.5.h,
                            fontFamily: "Poppins",
                            fontsize: 15.sp,
                            fontweight: FontWeight.w500,
                          ),
                        );
                      }),
                    );
                  }),

                  SizedBox(width: 2.w),
                  buildFilterDropdown(context),
                  // GestureDetector(
                  //   onTap: () => _buildFilterDropdown(context),
                  //   child: Container(
                  //     height: 4.5.h,
                  //     width: 10.5.w,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFF5E6D3),
                  //       borderRadius: BorderRadius.circular(17.sp),
                  //     ),
                  //     child: Icon(
                  //       Icons.tune_rounded,
                  //       color: buttonColor,
                  //       size: 16.sp,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 1.h),

            Expanded(
              child: RefreshIndicator(
                backgroundColor :containerColor,
                color: white,
                onRefresh: () => controller.refreshRequests(),
                child: Obx(() {
                  if (controller.trackRequestLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    );
                  }

                  final books = controller
                      .filteredTrackRequest;

                  return ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount: books.isEmpty
                        ? 1
                        : books.length + (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (books.isEmpty) {
                        return SizedBox(
                          height: 62.h,
                          child:  Center(
                            child: customText(
                              text: "No Tracking Request",
                              color: greyColor,
                              fontSize: 15.sp,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      if (index == books.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(color: buttonColor),
                          ),
                        );
                      }
                      final book = books[index];

                      // Safe Date Formatting
                      String formattedDate = "Joined: N/A";
                      try {
                        if (book.uploadDate.isNotEmpty) {
                          final DateTime dateTime = DateTime.parse(
                              book.uploadDate);
                          formattedDate = "Joined: ${DateFormat('dd MMMM, yyyy')
                              .format(dateTime)}";
                        }
                      } catch (e) {
                        debugPrint("Date Parsing Error: $e");
                        formattedDate = "Joined: Invalid Date";
                      }

                      return recentlySignedBooks(
                        imageUrl: book.coverImage,
                        bookTitle: book.title,
                        authorName: book.author.fullName,
                        date: formattedDate,
                        trackRequest: () {

                          print("DEBUG: Sending book title: ${book.title}");


                          if (book != null) {
                            Get.toNamed("/tracking", arguments: {'autographRequestId': book.id});
                          }
                          else {

                          }
                        },


                        status: book.status,
                        imagePath: '',
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
        } else if (value.startsWith("sort:")) {
          controller.sortBy.value = value.replaceFirst("sort:", "");
        } else if (value.startsWith("status:")) {
          controller.filterStatus.value = value.replaceFirst("status:", "");
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
          size: 18.sp,
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
    "Submitted",
    "Rejected",
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