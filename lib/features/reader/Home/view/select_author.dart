import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/select_author_controller.dart';
import 'package:storysign/features/reader/Home/widgets/reader/widget_select_author.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';

import '../../../../widgets/search_widget.dart';

import '../../search/widgets/header_widget.dart';


class SelectAuthor extends GetView<SelectAuthorController> {
  const SelectAuthor({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(
              context: context,
              title: "Select Author",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
            searchWidget(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              hintText: 'Search authors',
            ),

            SizedBox(height: 0.5.h),
            Obx(() {
              if (controller.isFetchHome.value) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: buttonColor),
                  ),
                );
              }

              if (controller.filteredAuthors.isEmpty) {
                return Expanded(
                  child: Center(
                    child: customText(
                      text: "No author",
                      fontSize: 15.sp,
                      color: greyColor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              final authorsList = controller.filteredAuthors;
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                    controller.loadAllData(),
                  backgroundColor :containerColor,
                  color: white,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: authorsList.length,
                    itemBuilder: (context, index) {
                      final author = authorsList[index];
                      const active = true;
                      return WidgetSelectAuthor(
                        imagePath: author.profilePicture?.toString() ?? "",
                        bookTitle: author.fullName,
                        date: "Joined: ${author.dateJoined.day}/${author.dateJoined.month}/${author.dateJoined.year}",
                        isActive: active,
                        ontap: () {
                          if (active) {
                            Get.back(result: {
                              'id': author.id,
                              'name': author.fullName,
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            }),

          ],
        ),
      ),
    );
  }
}
