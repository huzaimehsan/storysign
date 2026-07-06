import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../widgets/customText_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../search/widgets/header_widget.dart';
import '../../widgets/reader/request_detail_widget.dart';
import '../../widgets/reader/tracking_widget.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            RequestDetailWidget(
              imagePath: "assets/png/book.png",
              bookTitle: "The Great Gatsby",
              authorName: "Matt Haig",
              showSubmittedBadge: true,
              status: 'submitted',
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
                    buildInfoCard(
                      imagePath: "assets/png/confirmed.png",
                      title: "Payment Confirmed",
                      subtitle: "\$10.00 Charged",
                      date: "11 Jun, 2026",
                    ),
                    SizedBox(height: 2.h),
                   buildInfoCard(
                      imagePath: "assets/png/confirmed.png",
                      title: "Submitted",
                      subtitle: "Autograph request",
                      date: "12 Jun, 2026",
                    ),
                    SizedBox(height: 2.h),
        
                    buildInfoCard(
                      imagePath: "assets/png/noconfirm.png",
                      title: "Author Review",
                      subtitle: "Request in review",
                      date: "13 Jun, 2026",
                    ),
                    SizedBox(height: 2.h),
                     buildInfoCard(
                      imagePath: "assets/png/noconfirm.png",
                      title: "Delivered",
                      subtitle: "Request in review",
                      date: "14 Jun, 2026",
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
