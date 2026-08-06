import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/delivered/controller/delivered_controller.dart';
import 'package:storysign/features/author/request/controller/all_request_controller.dart';
import 'package:storysign/features/author/request/widget/all_pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../../reader/Home/widgets/reader/user_profile_card.dart';

class DeliveredScreen extends GetView<DeliveredController> {
  const DeliveredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  customHeaderAuthor(
                    context: context,
                    title: 'All Delivered Request',
                    onBack: () => Get.back(),
                    onIconPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            searchWidget(
              controller: controller.searchController,
              onChanged: controller.filterRequests,
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: sectionHeader(
                title: "Delivered Requests",
                onSeeAll: () {},
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: containerColor,
                color: white,
                onRefresh: () => controller.fetchDeliveryRequests(),
                child: Obx(() {
                  if (controller.isFetchPending.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return SizedBox(
                      height: 60.h,
                      child: Center(
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

                  if (controller.filteredRequests.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 40.h),
                        Center(
                          child: customText(
                            text: "No delivered requests",
                            // Updated text for delivered items
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: greyColor,
                            fontFamily: "Poppins",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount: controller.filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = controller.filteredRequests[index];
                      return AllPendingRequest(
                        imagePath: request.reader!.profilePicture ?? "",
                        authorName:
                            request.reader!.fullName ?? 'Unknown Author',
                        bookName: request.bookTitle ?? 'Unknown Book',
                        date: request.requestDate?.toString() ?? 'Unknown',
                        ontap: () {
                          Navigator.of(context).pushNamed(
                            '/requestDetail',
                            arguments: {
                              'from': 'all_delivered',
                              'autographRequestId': request.id,
                            },
                          );
                          // Get.(
                          //   '/requestDetail',
                          //   arguments: {
                          //
                          //   },
                          // );
                        },
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
}
