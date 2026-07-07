import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/home/widgets/author_profile_widget.dart';
import 'package:storysign/features/author/home/widgets/pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../../reader/Home/widgets/reader/user_profile_card.dart';
import '../controller/author_home_controller.dart';
import '../widgets/active_subscription.dart';
import '../widgets/book_info_widget.dart';

class AuthorHomeScreen extends GetView<AuthorHomeController> {
  AuthorHomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            buildProfileCard(name: 'Hello Aldito'),
            SizedBox(height: 2.h),
            searchWidget(
              controller: controller.searchController,
              onChanged: controller.filterRequests,
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 5.5.w,
              runSpacing: 1.5.h,
              alignment: WrapAlignment.center,
              children: [
                bookInfoWidget(
                  title: 'Signed Request',
                  value: '12',
                  backgroundColor: buttonColor,
                  textColor: bottomNavColor,
                  subtitle: 'Pending till date',
                  subtitleColor: bottomNavColor,
                ),
                bookInfoWidget(
                  title: 'Signed Books',
                  value: '24',
                  backgroundColor: white,
                  textColor: secondryColor,
                  subtitle: 'This Month',
                ),
                bookInfoWidget(
                  title: 'Remaining Sign',
                  value: '8',
                  backgroundColor: bottomNavColor,
                  textColor: buttonColor,
                  subtitle: 'Pending till date',
                ),
              ],
            ),
            activeSubscription(
              ontap: (){

                Get.toNamed('/plan');
              },
              title: 'Active Subscription',
              price: 'Basic. ',
              date: ' \$' "99",
              status: 'Manage',
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: sectionHeader(
                title: "Pending Requests",
                onSeeAll: () {},
              ),
            ),
            Obx(
              () => Expanded(
                child:

                controller.filteredRequests.isEmpty
                    ? Center(
                  child: customText(
                    text: "No pending requests",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                    textAlign: TextAlign.center,
                  ),
                ):
                SingleChildScrollView(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 12.h),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = controller.filteredRequests[index];
                      return PendingRequest(
                        imagePath: request['imagePath'] ?? '',
                        authorName: request['authorName'] ?? '',
                        date: request['date'] ?? '',
                        authorDetail: () {
                          Get.toNamed("/allRequest");
                        },
                        bookName: request['bookName'] ?? '',
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
