import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
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

                final books = controller.filteredAuthors;
                if (books.isEmpty) {
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
                     Navigator.of(context).pushNamed('/authordetail');
                      },
                      authorDetail: () {
                        Navigator.of(context).pushNamed('/authordetail');
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
