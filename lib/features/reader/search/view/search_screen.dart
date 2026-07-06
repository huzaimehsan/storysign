import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../widgets/search_widget.dart';
import '../controller/search_page_controller.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_author_widget.dart';

class SearchScreen extends GetView<SearchPageController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                final list = controller.filteredAuthors;
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 12.h),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final author = list[index];
                    return SearchAuthorCard(
                      imagePath: author["imagePath"]!,
                      bookTitle: author["bookTitle"]!,
                      date: author["date"]!,
                      requestAutoGraph: () {
                        Get.toNamed('/authordetail');
                      },
                      authorDetail: () {
                        Get.toNamed('/authordetail');
                      },
                    );
                  },
                );
              }),
            ),
        
        
          ],
        ),
      ),
    );
  }
}
