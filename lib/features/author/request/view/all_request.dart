import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/request/controller/all_request_controller.dart';
import 'package:storysign/features/author/request/widget/all_pending_request.dart';

import '../../../../widgets/search_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../../reader/Home/widgets/reader/user_profile_card.dart';

class AllRequest extends GetView<AllRequestController> {
  const AllRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 12.h),
        
                  itemCount: controller.filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = controller.filteredRequests[index];
                    return AllPendingRequest(
                      imagePath: request['imagePath'] ?? '',
                      authorName: request['authorName'] ?? '',
                      bookName: request['bookName'] ?? '',
                      date: request['date'] ?? '',
                      ontap: () {
                        Navigator.of(context).pushNamed('/requestDetail');
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
