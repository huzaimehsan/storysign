import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../model/home_model.dart';
import '../../search/widgets/header_widget.dart';
import '../widgets/reader/request_detail_widget.dart';
import '../widgets/reader/tracking_widget.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Arguments se data safe tarike se nikalna
    final args = Get.arguments;
    if (args == null || args['bookData'] == null) {
      return Scaffold(
        body: Center(child: customText(text: "Error: Book data not found!")),
      );
    }

    final BookItem book = args['bookData'] as BookItem;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Request Submitted",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
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

            // Dynamic Book Detail
            RequestDetailWidget(
              imagePath: book.coverImage,
              bookTitle: book.title,
              authorName: book.author?.fullName ?? 'Unknown',
              showSubmittedBadge: true,
              status: book.status,
            ),

            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customText(
                fontFamily: "Poppins",
                text: "Status",
                color: whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),

            // Status Cards ka updated logic
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(18.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. Payment Card
                    buildInfoCard(
                      imagePath: (book.status.toLowerCase() == "paid" || book.status.toLowerCase() == "delivered")
                          ? "assets/png/confirmed.png" : "assets/png/noconfirm.png",
                      title: "Payment Status",
                      subtitle: (book.status.toLowerCase() == "paid" || book.status.toLowerCase() == "delivered")
                          ? "Paid: \$${book.status.toLowerCase() ?? '0'}" : "Payment Pending",
                      date: (book.uploadDate != null && book.uploadDate!.isNotEmpty) ? book.uploadDate!.split('T')[0] : "N/A",
                    ),
                    SizedBox(height: 2.h),

                    // 2. Submitted Card
                    buildInfoCard(
                      imagePath: "assets/png/confirmed.png",
                      title: "Submitted",
                      subtitle: "Autograph request",
                      date: (book.uploadDate != null && book.uploadDate!.isNotEmpty) ? book.uploadDate!.split('T')[0] : "N/A",
                    ),
                    SizedBox(height: 2.h),

                    // 3. Author Review Card
                    buildInfoCard(
                      imagePath: (book.status.toLowerCase() == "in process" || book.status.toLowerCase() == "delivered")
                          ? "assets/png/confirmed.png" : "assets/png/noconfirm.png",
                      title: "Author Review",
                      subtitle: book.status.toLowerCase() == "submitted" ? "Request in review" : "Reviewed by author",
                      date: "---",
                    ),
                    SizedBox(height: 2.h),

                    // 4. Delivered Card
                    buildInfoCard(
                      imagePath: book.status.toLowerCase() == "delivered" ? "assets/png/confirmed.png" : "assets/png/noconfirm.png",
                      title: "Delivered",
                      subtitle: book.status.toLowerCase() == "delivered" ? "Request Completed" : "Waiting for delivery",
                      date: "---",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}