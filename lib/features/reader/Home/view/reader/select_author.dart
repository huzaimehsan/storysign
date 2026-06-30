import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/widgets/reader/widget_select_author.dart';

import '../../../../../widgets/custom_text_feild.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../search/widgets/author_detail_widget.dart';
import '../../../search/widgets/file_upload_widget.dart';
import '../../../search/widgets/header_widget.dart';
import '../../../search/widgets/search_author_widget.dart';

class SelectAuthor extends StatelessWidget {
  const SelectAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            searchWidget(),

            SizedBox(height: 0.5.h),
            WidgetSelectAuthor(
              imagePath: "assets/png/searchprofile.png",
              bookTitle: "Matt Haig",
              date: "Joined: 22 june, 2026",
              authorDetail: () {

              }, activity: 'Active',
            ),

            WidgetSelectAuthor(
              imagePath: "assets/png/searchprofile.png",
              bookTitle: "Matt Haig",
              date: "Joined: 22 june, 2026",
              authorDetail: () {

              }, activity: 'Active',
            ),
            WidgetSelectAuthor(
              imagePath: "assets/png/searchprofile.png",
              bookTitle: "Matt Haig",
              date: "Joined: 22 june, 2026",
              authorDetail: () {

              }, activity: 'Inactive',
            ),
            WidgetSelectAuthor(
              imagePath: "assets/png/searchprofile.png",
              bookTitle: "Matt Haig",
              date: "Joined: 22 june, 2026",
              authorDetail: () {

              }, activity: 'Active',
            ),
          ],
        ),
      ),
    );
  }
}
