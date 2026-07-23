import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/signed_copy_controller.dart';
import 'package:storysign/widgets/formatted_date_widget.dart';

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

    final String requestId =
        args['requestId']?.toString() ??
        args['autographRequestId']?.toString() ??
        args['bookData']?.toString() ??
        '';

    final String bookName = args['bookName']?.toString() ?? 'Unknown Book';

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
              // 1. First Obx (Book Detail ke liye)
              Obx(() {
                final book = controller.selectedRequest.value;

                // Agar data abhi tak load nahi hua, toh loading dikhayein
                if (book == null) {
                  return SizedBox(
                    height: 30.h,
                    child: const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    ),
                  );
                }

                return recentlySignedBooks(
                  imageUrl: book.coverImage ?? "",
                  bookTitle: book.title,
                  authorName: book.author.fullName,
                  date: book.uploadDate.isNotEmpty
                      ? DateFormat(
                          'dd MMM, hh:mm a',
                        ).format(DateTime.parse(book.uploadDate).toLocal())
                      : '',
                  status: book.status,
                  trackRequest: () {},
                  showArrow: false,
                  imagePath: '',
                  showAuthor: true,
                );
              }),

              SizedBox(height: 1.h),

              // 2. Second Obx (Message Card ke liye)
              Obx(() {
                final book = controller.selectedRequest.value;

                if (book == null) {
                  return const SizedBox.shrink(); // Jab tak data na aaye, kuch na dikhayein
                }

                return signedCopyMessageCard(
                  title: "Message",
                  message: book.authorMessage ?? "",
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                );
              }),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: buttonWidget(
                  "Download Book",
                  whiteColor,
                  onTap: () {
                    controller.downloadBook(requestId, bookName);
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: buttonWidget(
                  "Back To Dashboard",
                  whiteColor,
                  onTap: () {
                    Get.offAllNamed(
                      'bottomnav',
                    ); // Ya Get.offAllNamed('/home') agar dashboard par wapas jana ho
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
