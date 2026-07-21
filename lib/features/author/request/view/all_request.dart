import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/home/controller/home_controller.dart';
import 'package:storysign/features/author/request/controller/all_request_controller.dart';
import 'package:storysign/features/author/request/widget/all_pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../../reader/Home/widgets/reader/user_profile_card.dart';

class AllRequest extends GetView<AuthorHomeController> {
  const AllRequest({super.key});

  String _formatRequestDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM, hh:mm a').format(dateTime.toLocal());
    } catch (_) {
      return dateString;
    }
  }

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
                    title: 'All Request',
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
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: sectionHeader(title: "Pending Requests", onSeeAll: () {}),
            ),

            Obx(
                  () => Expanded(
                child: controller.isFetchPending.value
                    ? Center(
                  child: customText(
                    text: "No pending requests",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.only(bottom: 12.h),
                  itemCount: controller.autographList.length,
                  itemBuilder: (context, index) {
                    final request = controller.autographList[index];
                    final formattedDate = _formatRequestDate(request.requestDate);
                    return AllPendingRequest(
                      imagePath: request.reader.profilePicture,
                      authorName: request.author.fullName,
                      bookName: request.bookTitle,
                      date: formattedDate,
                      ontap: () {
                        Navigator.of(context).pushNamed('/requestDetail' ,arguments: {'from': 'all_request'});
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
