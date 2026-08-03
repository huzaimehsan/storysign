import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/sucess_widget.dart';
import '../../Home/widgets/reader/custom_text_field_with_limit.dart';
import '../../Home/widgets/reader/fee_field_with_price.dart';
import '../../Home/widgets/reader/request_detail_widget.dart';
import '../../search/widgets/header_widget.dart';
import '../controller/library_detail_controller.dart';

class ReaderLibraryDetailScreen extends GetView<ReaderLibraryDetailController> {
  const ReaderLibraryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String bookId = Get.arguments?['bookId']?.toString() ?? '';

    if (bookId.isNotEmpty) {
      controller.fetchBookDetail(bookId);
    }

    return Scaffold(
      backgroundColor: containerColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: 30.h,
              child: const Center(child: CircularProgressIndicator(color: buttonColor)),
            );
          }

          final detail = controller.detail.value;
          if (detail == null) {
            return Center(
              child: customText(text: 'No details available', color: greyColor, fontSize: 14.sp),
            );
          }

          final dateText = detail.uploadDate.isNotEmpty
              ? DateFormat('dd MMM, yyyy').format(DateTime.tryParse(detail.uploadDate) ?? DateTime.now())
              : 'Joined recently';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customHeader(
                  context: context,
                  title: 'Book Detail',
                  onBack: () => Get.back(),
                  onIconPressed: () {},
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: customText(
                    text: 'Book Detail',
                    color: whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                RequestDetailWidget(
                  imagePath: detail.coverImage,
                  bookTitle: detail.title,
                  authorName: detail.authorName.isEmpty ? 'Unknown' : detail.authorName,
                  status: detail.status.isEmpty ? 'Unknown' : detail.status,
                  showSubmittedBadge: true,
                ),


                detail.authorName == null || detail.authorName!.isEmpty ?
                    SizedBox.shrink() :
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      SizedBox(height: 1.h,),
                      customText(
                        text: 'About Author',
                        color: whiteColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  )
                ),
                SizedBox(height: 0.5.h),
                detail.authorName == null || detail.authorName!.isEmpty
                    ? const SizedBox.shrink()
                    : AuthorInfoCard(
                  imagePath: detail.authorProfilePicture ?? '',
                  bookTitle: detail.authorName!,
                  date: dateText,
                ),
                SizedBox(height: 1.5.h),
                FeeFieldWithPrice(
                  label: 'Signature Price',
                  price: detail.isPaid ? 'Paid' : 'Fee',
                  amount: '${detail.feeAmount}',
                  isPaid: detail.isPaid,
                ),
                SizedBox(height: 7.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: !detail.isPaid
                      ? buttonWidget(
                    'Request Autograph',
                    whiteColor,
                    onTap: () => Get.toNamed('/requestautographcard', arguments: {
                      'bookId': detail.id,
                      'bookTitle': detail.title,
                      'role': 'fromLibrary',
                    }),
                    colors: buttonColor,
                    fontweight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    height: 5.2.h,
                    width: double.infinity,
                    fontsize: 16.sp,
                  )
                      : const SizedBox.shrink(),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
