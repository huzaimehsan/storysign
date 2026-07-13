import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../widgets/header_widget.dart';
class AuthorDetail extends GetView<HomeController> {
  const AuthorDetail({super.key});

  @override
  Widget build(BuildContext context) {

    final args = (Get.arguments is Map<String, dynamic>)
        ? Get.arguments as Map<String, dynamic>
        : ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final authorId = args?['authorId']?.toString();
    final role = args?['role']?.toString();
    if (authorId != null && authorId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('AuthorDetail opened for id: $authorId; cached: ${controller.authorDetailData.value?.id}');

        final currentId = controller.authorDetailData.value?.id?.toString();
        if (currentId != authorId && !controller.isLoading.value) {
          controller.authorDetail(authorId);
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            final author = controller.authorDetailData.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customHeader(
                  context: context,
                  title: "Author Detail",
                  onBack: () => Get.back(),
                  onIconPressed: () {},
                ),

                SizedBox(height: 1.h),

                if (controller.isLoading.value)
                  SizedBox(
                    height: 40.h,
                    child: const Center(child: CircularProgressIndicator()),
                  )

                else ...[
                  AuthorInfoCard(
                    imagePath: author?.profilePicture,
                    bookTitle: author?.fullName ?? 'Author',
                    date: author?.dateJoined,
                  ),

                  SizedBox(height: 1.h),

                  AuthorBiographyCard(
                      description: author?.bio ?? 'No biography available.'),
                  SizedBox(height: 10.h),
            // role 'allAuthor' na ho, tabhi button dikhe
            role != 'allAuthor'
            ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: buttonWidget(
            "Request Autograph",
            whiteColor,
            onTap: () => Get.toNamed('/requestautograph'),
            colors: buttonColor,
            fontFamily: 'Poppins',
            height: 5.2.h,
            width: double.infinity,
            fontsize: 16.sp,
            fontweight: FontWeight.w600,
            ),
            )
                : const SizedBox.shrink(), // Agar role 'allAuthor' hai, toh button nahi dikhega

                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
