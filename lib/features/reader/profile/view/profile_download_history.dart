import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/profile/controller/profile_download_history_controller.dart';
import 'package:storysign/features/reader/search/widgets/header_widget.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../widget/download_history_card.dart';

class ProfileDownloadHistoryScreen
    extends GetView<ProfileDownloadHistoryController> {
  const ProfileDownloadHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isbookLoading.value && controller.bookList.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: buttonColor)),
        );
      }

      // if (controller.errorMessage.value.isNotEmpty && controller.bookList.isEmpty) {
      //   return Scaffold(
      //     body: Center(
      //       child: customText(
      //         text: controller.errorMessage.value,
      //         color: greyColor,
      //         fontSize: 15.sp,
      //         fontFamily: "Poppins",
      //         fontWeight: FontWeight.w500,
      //       ),
      //     ),
      //   );
      // }

      final books = controller.filteredBooks;

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header
              customHeader(
                context: context,
                title: "Download History",
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 1.h),

              // Search Bar
              searchWidget(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
              ),
              SizedBox(height: 0.5.h),
              // Books List
              Expanded(
                child: books.isEmpty
                    ? Center(
                        child: customText(
                          text: "No downloads found",
                          color: greyColor,
                          fontSize: 15.sp,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : RefreshIndicator(
                        backgroundColor: containerColor,
                        color: white,
                        onRefresh: () => controller.refreshHistory(),
                        child: ListView.builder(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          itemCount:
                              books.length +
                              (controller.isLoadingMoreHistory.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == books.length) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: const CircularProgressIndicator(
                                    color: buttonColor,
                                  ),
                                ),
                              );
                            }
                            final book = books[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 0.1.h),
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    '/signedcopy',
                                    arguments: {
                                      'bookId': book.bookId,
                                      'autographRequestId':
                                          book.autographRequestId ?? '',
                                      'bookName': book.bookTitle,
                                      'isFromDownloadHistory': true,
                                    },
                                  );
                                },
                                child: downloadHistoryCard(
                                  imagePath: book.coverImage ?? "",
                                  title: book.bookTitle,
                                  date: book.createdAt.toString().split(' ')[0],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
