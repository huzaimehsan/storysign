import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/search/widgets/header_widget.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';

import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../controller/view_all_books_controller.dart';

class ViewAllBooksScreen extends GetView<ViewAllBooksController> {
  const ViewAllBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isBookLoading.value && controller.books.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: buttonColor)),
        );
      }

      if (controller.errorMessage.value.isNotEmpty && controller.books.isEmpty) {
        return Scaffold(
          body: Center(
            child: customText(
              text: controller.errorMessage.value,
              color: greyColor,
              fontSize: 15.sp,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      final books = controller.filteredBooks;

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header
               customHeader(
                context: context,
                title: "All Signed Books",
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 1.h),

              // Search Bar
              searchWidget(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
              ),
              SizedBox(height: 1.5.h),

              // Filter & Sort Options
       

              // Books List
              Expanded(
                child: books.isEmpty
                    ? Center(
                        child: customText(
                          text: "No books found",
                          color: greyColor,
                          fontSize: 15.sp,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : RefreshIndicator(
                        backgroundColor: containerColor,
                        color: white,
                        onRefresh: () => controller.refreshBooks(),
                        child: ListView.builder(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                         
                     
                          ),
                          itemCount: books.length +
                              (controller.isLoadingMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == books.length) {
                              return Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(),
                                  child: const CircularProgressIndicator(
                                    color: buttonColor,
                                  ),
                                ),
                              );
                            }
                            final book = books[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 0.h),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    "/signedcopy",
                                    arguments: {
                                      'autographRequestId':
                                          book.autographRequestId,
                                      'bookId': book.bookId,
                                      'bookPdfUrl': book.signedPdfUrl,
                                    },
                                  );
                                },
                                child: recentlySignedBooks(
                                  imageUrl: book.coverImage,
                                  bookTitle: book.title,
                                  date: book.uploadDate
                                      .toString()
                                      .split(' ')[0],
                                  status: book.status,
                                  authorName: book.authorName,
                                  trackRequest: () {
                                    Get.toNamed(
                                      "/signedcopy",
                                      arguments: {
                                        'autographRequestId':
                                            book.autographRequestId,
                                        'bookId': book.bookId,
                                        'bookPdfUrl': book.signedPdfUrl,
                                      },
                                    );
                                  },
                                  imagePath: '',
                                  showAuthor: true,
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
