import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';
import 'package:storysign/features/reader/Home/widgets/reader/widget_select_author.dart';
import '../../../../constants/color_constants.dart';
import '../model/home_model.dart';

import '../../../../widgets/custom_text_feild.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/author_detail_widget.dart';
import '../../search/widgets/file_upload_widget.dart';
import '../../search/widgets/header_widget.dart';
import '../../search/widgets/search_author_widget.dart';

class SelectAuthor extends GetView<HomeController> {
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
              onChanged: (value) => controller.searchQuery.value = value,
              hintText: 'Search authors',
            ),

            SizedBox(height: 0.5.h),
            Obx(() {

              if (controller.trackRequestLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: buttonColor),
                );
              }
              final authorsList = controller.filteredAuthors;
              return Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                          // SelectAuthor Screen mein

                            if (active) {

                              Get.back(result: author.id);

                          };
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
