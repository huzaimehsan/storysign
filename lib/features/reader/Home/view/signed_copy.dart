import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/signed_copy_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/book_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../search/widgets/header_widget.dart';

class SignedCopy extends GetView<SignedCopyController> {
  const SignedCopy({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely extract arguments
    final Map<String, dynamic> args =
        Get.arguments as Map<String, dynamic>? ?? {};

    final String bookId =
        args['bookId']?.toString() ??
        args['bookIdValue']?.toString() ??
        args['bookData']?.toString() ??
        '';

    final String requestId =
        args['requestId']?.toString() ??
        args['autographRequestId']?.toString() ??
        '';

    final String bookName = args['bookName']?.toString() ?? 'Unknown Book';
    final bool isFromDownloadHistory = args['isFromDownloadHistory'] == true;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customHeader(
                context: context,
                title: "",
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 2.h),
              Center(
                child: Image.asset(
                  "assets/png/signedcopy.png",
                  height: 13.w,
                  width: 13.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 2.h),
              Center(
                child: customText(
                  fontFamily: "Poppins",
                  text: "Your signed copy is available",
                  color: bottomNavColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: customText(
                  fontFamily: "Poppins",
                  text: "Book Detail",
                  color: whiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),

              Obx(() {
                final book = controller.selectedRequest.value;

                if (book == null) {
                  return SizedBox(
                    height: 29.7.h,
                    child: const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    ),
                  );
                }

                return recentlySignedBooks(
                  imageUrl: book.coverImage,
                  bookTitle: book.title,
                  authorName: book.author.fullName,
                  date: book.uploadDate.isNotEmpty ? book.uploadDate : '',
                  dateFormat: 'dd MMM yyyy',
                  status: book.status,
                  trackRequest: () {},
                  showArrow: false,
                  imagePath: '',
                  showAuthor: true,
                );
              }),

              SizedBox(height: 1.h),

              Obx(() {
                final book = controller.selectedRequest.value;

                if (book == null) {
                  return const SizedBox.shrink();
                }

                return signedCopyMessageCard(
                  title: "Message",
                  message: book.authorMessage ?? "",
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                );
              }),
              SizedBox(height: 5.h),
              if (!isFromDownloadHistory) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: buttonWidget(
                    "Download Book",
                    whiteColor,
                    onTap: () {
                      controller.downloadBook(bookId, bookName);
                    },
                    colors: buttonColor,
                    fontFamily: 'Poppins',
                    height: 5.2.h,
                    width: double.infinity,
                    fontsize: 16.sp,
                    fontweight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.5.h),
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: buttonWidget(
                  "Back To Dashboard",
                  whiteColor,
                  onTap: () {
                    Get.offAllNamed('bottomnav');
                  },
                  colors: greyColor,
                  fontFamily: 'Poppins',
                  height: 5.2.h,
                  width: double.infinity,
                  fontsize: 16.sp,
                  fontweight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
