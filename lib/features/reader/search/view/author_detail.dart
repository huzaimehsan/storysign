import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../bottomNav/controller/bottom_nav_controller.dart';
import '../controller/search_page_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../widgets/header_widget.dart';

class AuthorDetail extends GetView<SearchPageController> {
  /// authorId and role passed directly as constructor params.
  /// This avoids Get.arguments vs ModalRoute.settings.arguments confusion
  /// when the screen is opened via both GetX global nav and nested Navigator.
  final String authorId;
  final String role;

  const AuthorDetail({super.key, required this.authorId, required this.role});

  @override
  Widget build(BuildContext context) {
    if (authorId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint(
          'AuthorDetail opened for id: $authorId; cached: ${controller.authorDetailData.value?.id}',
        );
        final currentId = controller.authorDetailData.value?.id;
        if (currentId != authorId) {
          controller.authorDetail(authorId);
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final author = controller.authorDetailData.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customHeader(
                context: context,
                title: "Author Detail",
                onBack: () {
                  final nav = Get.find<BottomNavController>()
                      .navigatorKeys[Get.find<BottomNavController>()
                          .currentIndex
                          .value]
                      .currentState;
                  if (nav != null && nav.canPop()) {
                    nav.pop(); // nested tab navigator (search screen)
                  } else {
                    Get.back(); // global GetX navigator (home screen)
                  }
                },
                onIconPressed: () {},
              ),

              SizedBox(height: 1.h),

              if (controller.isDetailLoading.value)
                SizedBox(
                  height: 40.h,
                  child: const Center(
                    child: CircularProgressIndicator(color: buttonColor),
                  ),
                )
              else ...[
                AuthorInfoCard(
                  imagePath: author?.profilePicture,
                  bookTitle: author?.fullName ?? 'Author',
                  date: author?.dateJoined,
                ),

                SizedBox(height: 1.h),

                AuthorBiographyCard(
                  description: author?.bio ?? 'No biography available.',
                ),
                SizedBox(height: 10.h),

                role != 'allAuthor'
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: buttonWidget(
                          "Request Autograph",
                          whiteColor,
                          onTap: () => Get.toNamed(
                            '/requestautograph',
                            arguments: {'authorId': authorId},
                          ),
                          colors: buttonColor,
                          fontFamily: 'Poppins',
                          height: 5.2.h,
                          width: double.infinity,
                          fontsize: 16.sp,
                          fontweight: FontWeight.w600,
                        ),
                      )
                    : Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 4.w),
                      child: buttonWidget(
                          "Back To Dashboard",
                          whiteColor,
                          onTap: () {
                            Get.back();
                          },
                          colors: btnColor,
                          height: 5.2.h,
                          fontFamily: 'Poppins',
                          width: double.infinity,
                          fontsize: 16.sp,
                          fontweight: FontWeight.w600,
                        ),
                    ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
