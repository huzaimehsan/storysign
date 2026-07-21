import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/home/widgets/author_profile_widget.dart';
import 'package:storysign/features/author/home/widgets/pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../../reader/Home/widgets/reader/user_profile_card.dart';
import '../controller/home_controller.dart';
import '../widgets/active_subscription.dart';
import '../widgets/book_info_widget.dart';

class AuthorHomeScreen extends GetView<AuthorHomeController> {
  AuthorHomeScreen({super.key});


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
            buildProfileCard(name: 'Hello Aldito'),
            SizedBox(height: 2.h),
            searchWidget(
              controller: controller.searchController,
              onChanged: controller.filterRequests,
            ),
            SizedBox(height: 1.h),
            Obx(() {
              if (controller.isStatsLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: buttonColor,),
                );
              }

              final stats = controller.authorStats.value;
              if (stats == null) {
                return SizedBox(
                  height: 15.h,
                  child: Center(
                    child: customText(
                      text: 'Unable to load stats',
                      color: whiteColor,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return Wrap(
                spacing: 5.5.w,
                runSpacing: 1.5.h,
                alignment: WrapAlignment.center,
                children: [
                  bookInfoWidget(
                    title: 'Sign Request',
                    value: stats.totalSignRequests.toString(), // '!' hata diya
                    backgroundColor: buttonColor,
                    textColor: bottomNavColor,
                    subtitle: 'Pending till date',
                    subtitleColor: bottomNavColor,
                  ),
                  bookInfoWidget(
                    title: 'Signed Books',
                    value: stats.signedBooks.toString(), // '!' hata diya
                    backgroundColor: white,
                    textColor: secondryColor,
                    subtitle: 'This Month',
                  ),
                  bookInfoWidget(
                    title: 'Remaining Sign',
                    value: stats.remainingSigns.toString(), // '!' hata diya
                    backgroundColor: bottomNavColor,
                    textColor: buttonColor,
                    subtitle: 'Pending till date',
                  ),
                ],
              );
            }),
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

                controller.isFetchPending.value
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
                    itemCount: controller.autographList.length,
                    itemBuilder: (context, index) {
                      final request = controller.autographList[index];
                      final formattedDate = _formatRequestDate(request.requestDate);
                      return PendingRequest(
                        imagePath: request.reader.profilePicture,
                        authorName: request.author.fullName,
                        date: formattedDate,
                        authorDetail: () {
                          Get.toNamed("/allRequest");
                        },
                        bookName:request.bookTitle,
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
