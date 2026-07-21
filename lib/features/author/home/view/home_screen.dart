import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: buttonColor, // Loading spinner ka color
        onRefresh: () => controller.refreshHomeRequests(),
        child: SafeArea(
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
                if (controller.isFetchPending.value && controller.authorStats.value == null) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: const CircularProgressIndicator(color: buttonColor),
                    ),
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
                      value: stats.totalSignRequests.toString(),
                      backgroundColor: buttonColor,
                      textColor: bottomNavColor,
                      subtitle: 'Pending till date',
                      subtitleColor: bottomNavColor,
                    ),
                    bookInfoWidget(
                      title: 'Signed Books',
                      value: stats.signedBooks.toString(),
                      backgroundColor: white,
                      textColor: secondryColor,
                      subtitle: 'This Month',
                    ),
                    bookInfoWidget(
                      title: 'Remaining Sign',
                      value: stats.remainingSigns.toString(),
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
              SizedBox(height: 1.h),

              // ListView direct Expanded ke andar taake RefreshIndicator properly kaam kare
              Expanded(
                child: Obx(() {
                  if (controller.isFetchPending.value && controller.autographList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    );
                  }

                  if (controller.autographList.isEmpty) {
                    return Center(
                      child: customText(
                        text: "No pending requests",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount: controller.autographList.length,
                    itemBuilder: (context, index) {
                      final request = controller.autographList[index];
                      return PendingRequest(
                        imagePath: request.reader.profilePicture,
                        authorName: request.author.fullName,
                        date: request.requestDate,
                        authorDetail: () {
                          Navigator.of(context).pushNamed(
                            '/requestDetail',
                            arguments: {
                              'from': 'home',
                              'autographRequestId': request.id,
                            },
                          );
                        },
                        bookName: request.bookTitle,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}