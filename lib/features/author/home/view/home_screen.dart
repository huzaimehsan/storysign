import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/home/widgets/author_profile_widget.dart';
import 'package:storysign/features/author/home/widgets/pending_request.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';

import '../controller/home_controller.dart';
import '../widgets/active_subscription.dart';
import '../widgets/book_info_widget.dart';

class AuthorHomeScreen extends GetView<AuthorHomeController> {
  AuthorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPageLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: buttonColor)),
        );
      }

      return Scaffold(
        body: SafeArea(
          bottom: false,
          child:  RefreshIndicator(
                  backgroundColor: containerColor,
                  color: white,
                  onRefresh: () => controller.refreshHomeRequests(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                       Obx(() {
  final authorProfile = controller.userAuthorProfile.value;
  final role = controller.userRole.value;
  final fullName = authorProfile?.fullName ?? '';

  return buildProfileCard(
    imagePath: authorProfile?.profilePicture ?? '',
    name: fullName.isNotEmpty ? fullName : 'User',
    role: role.isNotEmpty ? role : null,
  );
}),
                        SizedBox(height: 2.h),

                        // Search Bar — filterRequests se connected
                        searchWidget(
                          controller: controller.searchController,
                          onChanged: controller.filterRequests,
                        ),
                        SizedBox(height: 1.h),

                        // Stats Section
                        Obx(() {
                          final stats = controller.authorStats.value;
                          if (stats == null) {
                            return SizedBox(
                              height: 10.h,
                              child: Center(
                                child: customText(
                                  text: 'Unable to load stats',
                                  color: greyColor,
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

                        Obx(() {
                          final active = controller.activeSub.value;
                          if (active == null) {
                            return const SizedBox.shrink();
                          }
                          return activeSubscription(
                            ontap: () {
                              Get.toNamed(
                                '/plan',
                                arguments: {
                                  'planId': active.planId,
                                  'planName': active.planName,
                                },
                              );
                            },
                            title: 'Active Subscription',
                            price: active.planName,
                            date: '\$${active.amountPaid.toStringAsFixed(2)}',
                            status: 'Manage',
                          );
                        }),
                        SizedBox(height: 0.5.h),

                        Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: customText(
                  text: "Pending Requests",
                  color: whiteColor,
                  fontSize: 16.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
                        SizedBox(height: 0.5.h),

                        // Pending Requests List
                        Obx(() {
                          final list = controller.filteredAutographList;

                          if (list.isEmpty) {
                            return SizedBox(
                              height: 25.h,
                              child: Center(
                                child: customText(
                                  text: controller.searchQuery.value.isNotEmpty
                                      ? "No results found for \"${controller.searchQuery.value}\""
                                      : "No pending requests",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: greyColor,
                                  fontFamily: 'Poppins',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          final visibleList = list.take(3).toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 12.h),
                            itemCount: visibleList.length,
                            itemBuilder: (context, index) {
                              final request = visibleList[index];
                              return PendingRequest(
                                imagePath: request.reader.profilePicture,
                                authorName: request.reader.fullName,
                                date: request.requestDate,
                                authorDetail: () => controller.goToRequestsTab(),
                                bookName: request.bookTitle,
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
