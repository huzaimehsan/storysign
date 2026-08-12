import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/tracking_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../search/widgets/header_widget.dart';
import '../widgets/reader/request_detail_widget.dart';
import '../widgets/reader/tracking_widget.dart';

class TrackingScreen extends GetView<TrackingController> {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isloading.value) {
            return const Center(
              child: CircularProgressIndicator(color: buttonColor),
            );
          }

          final tracking = controller.trackingModel.value;
          final statusLabel = humanizeStatus(tracking?.status);
          final statusLower = statusLabel.toLowerCase();
          final statusNormalized = statusLower
              .replaceAll('_', ' ')
              .replaceAll('-', ' ')
              .trim();
          final isPaidState =
              tracking?.isPaid == true ||
              statusNormalized == 'paid' ||
              statusNormalized == 'delivered';
          final isSubmittedStageComplete =
              statusNormalized == 'submitted' ||
              statusNormalized == 'in process' ||
              statusNormalized == 'inprogress' ||
              statusNormalized == 'delivered' ||
              statusNormalized == 'paid';
          final isReviewStageComplete =
              statusNormalized == 'in process' ||
              statusNormalized == 'inprogress' ||
              statusNormalized == 'delivered' ||
              statusNormalized == 'paid';
          final isDeliveredStageComplete = statusNormalized == 'delivered';
          final paymentDate = displayDateLabel(tracking?.paidAt);
          final submittedDate = displayDateLabel(tracking?.submittedAt);
          final reviewDate = displayDateLabel(tracking?.inProgressAt);
          final deliveredDate = displayDateLabel(tracking?.deliveredAt);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customHeader(
                context: context,
                title: 'Tracking',
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: customText(
                  fontFamily: 'Poppins',
                  text: 'Book Detail',
                  color: whiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              if (tracking == null)
                Center(
                  child: customText(
                    text: 'No tracking details available',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
                )
              else
                RequestDetailWidget(
                  imagePath: tracking.coverImage,
                  bookTitle: safeText(tracking.bookTitle, fallback: 'Unknown'),
                  authorName: safeText(
                    tracking.author?.fullName,
                    fallback: 'Unknown',
                  ),
                  showSubmittedBadge: true,
                  status: statusLabel.isEmpty ? 'Submitted' : statusLabel,
                ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: customText(
                  fontFamily: 'Poppins',
                  text: 'Status',
                  color: whiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
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
                            imagePath: isPaidState
                                ? 'assets/png/confirmed.png'
                                : 'assets/png/noconfirm.png',
                            title: 'Payment Status',
                            subtitle: isPaidState
                                ? 'Paid: \$${tracking?.feeAmount ?? 0}'
                                : 'Payment Pending',
                            date: paymentDate,
                          ),
                          SizedBox(height: 2.h),
                          buildInfoCard(
                            imagePath: isSubmittedStageComplete
                                ? 'assets/png/confirmed.png'
                                : 'assets/png/noconfirm.png',
                            title: 'Submitted',
                            subtitle: 'Autograph request',
                            date: submittedDate,
                          ),
                          SizedBox(height: 2.h),
                          buildInfoCard(
                            imagePath: isReviewStageComplete
                                ? 'assets/png/confirmed.png'
                                : 'assets/png/noconfirm.png',
                            title: 'Author Review',
                            subtitle: statusLower == 'submitted'
                                ? 'Request in review'
                                : 'Reviewed by author',
                            date: reviewDate,
                          ),
                          SizedBox(height: 2.h),
                          buildInfoCard(
                            imagePath: isDeliveredStageComplete
                                ? 'assets/png/confirmed.png'
                                : 'assets/png/noconfirm.png',
                            title: 'Delivered',
                            subtitle: statusLower == 'delivered'
                                ? 'Request Completed'
                                : 'Waiting for delivery',
                            date: deliveredDate,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

String safeText(String? value, {String fallback = 'Unknown'}) {
  final text = value?.trim();
  return (text != null && text.isNotEmpty && text != 'null') ? text : fallback;
}

String displayDateLabel(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty || text == 'null') {
    return 'N/A';
  }

  final dateTime = DateTime.tryParse(text);
  if (dateTime != null) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  return text.split('T').first;
}

String humanizeStatus(String? value) {
  final normalized = safeText(value, fallback: '').toLowerCase();
  switch (normalized) {
    case 'submitted':
      return 'Submitted';
    case 'in process':
    case 'in_progress':
    case 'in_prgress':
    case 'inprogress':
    case 'in-progress':
      return 'In Process';
    case 'delivered':
      return 'Delivered';
    case 'paid':
      return 'Paid';
    case 'rejected':
      return 'Rejected';
    default:
      return normalized.isEmpty
          ? 'Submitted'
          : normalized[0].toUpperCase() + normalized.substring(1);
  }
}
