import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/delivered/controller/delivered_controller.dart';
import 'package:storysign/features/author/request/binding/request_detail_binding.dart';
import 'package:storysign/features/author/request/view/request_detail.dart';
import 'package:storysign/features/author/request/widget/all_pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';

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
                    onBack: () => controller.popTab(),
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: customText(
                  text: "Delivered Requests",
                  color: whiteColor,
                  fontSize: 15.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
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

                  // if (controller.errorMessage.value.isNotEmpty) {
                  //   return SizedBox(
                  //     height: 60.h,
                  //     child: Center(
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

                  if (controller.filteredRequests.isEmpty) {
                    return ListView(
                      controller: controller.scrollController,
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
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount:
                        controller.filteredRequests.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.filteredRequests.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: buttonColor,
                            ),
                          ),
                        );
                      }

                      final request = controller.filteredRequests[index];
                      return AllPendingRequest(
                        imagePath: request.reader!.profilePicture ?? "",
                        authorName:
                            request.reader!.fullName ?? 'Unknown Author',
                        bookName: request.bookTitle ?? 'Unknown Book',
                        date: request.requestDate?.toString() ?? 'Unknown',
                        ontap: () {
                          Navigator.of(context).push(
                            GetPageRoute(
                              page: () => const RequestDetailAuthor(),
                              binding: AuthorRequestDetailBinding(),
                              settings: RouteSettings(
                                name: '/requestDetail',
                                arguments: {
                                  'from': 'all_delivered',
                                  'autographRequestId': request.id,
                                },
                              ),
                            ),
                          );
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
