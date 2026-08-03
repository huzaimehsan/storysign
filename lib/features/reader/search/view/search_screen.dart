import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../bottomNav/controller/bottom_nav_controller.dart';
import '../controller/search_page_controller.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_author_widget.dart';

class SearchScreen extends GetView<SearchPageController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor :containerColor,
        color: white,
        onRefresh: () => controller.refreshSearchRequests(),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              customHeader(
                context: context,
                title: "All Authors",
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 2.h),

              searchWidget(
                onChanged: (val) {
                  controller.searchQuery.value = val;
                },
              ),

              SizedBox(height: 1.h),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    );
                  }
                  final list = controller.filteredAuthors;
                  if (list.isEmpty) {
                    return Center(
                      child: customText(
                        text: "No Author",
                        color: greyColor,
                        fontSize: 15.sp,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final author = list[index];
                      final formattedDate =
                          "Joined: ${DateFormat('dd MMMM, yyyy').format(author.dateJoined)}";
                      return SearchAuthorCard(
                        imagePath: author.profilePicture,
                        bookTitle: author.fullName,
                        date: formattedDate,
                        requestAutoGraph: () {
                          Get.find<BottomNavController>().pushInSearchTab(
                            '/authordetail',
                            arguments: {'authorId': author.id, 'role': 'search'},
                          );
                        },
                        authorDetail: () {
                          Get.find<BottomNavController>().pushInSearchTab(
                            '/authordetail',
                            arguments: {'authorId': author.id, 'role': 'search'},
                          );
                        },
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
