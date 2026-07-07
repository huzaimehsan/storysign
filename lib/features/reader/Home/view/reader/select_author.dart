import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/reader/Home/controller/reader/home_controller.dart';
import 'package:storysign/features/reader/Home/widgets/reader/widget_select_author.dart';

import '../../../../../widgets/custom_text_feild.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../search/widgets/author_detail_widget.dart';
import '../../../search/widgets/file_upload_widget.dart';
import '../../../search/widgets/header_widget.dart';
import '../../../search/widgets/search_author_widget.dart';

class SelectAuthor extends GetView<HomeController> {
  const SelectAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> authors = [
      {
        'imagePath': 'assets/png/searchprofile.png',
        'bookTitle': 'Madeline Miller',
        'date': 'Joined: 22 june, 2026',
        'active': true,
      },
      {
        'imagePath': 'assets/png/searchprofile.png',
        'bookTitle': 'Matt Haig',
        'date': 'Joined: 22 june, 2026',
        'active': true,
      },
      {
        'imagePath': 'assets/png/searchprofile.png',
        'bookTitle': 'Colleen Hoover',
        'date': 'Joined: 22 june, 2026',
        'active': false,
      },
      {
        'imagePath': 'assets/png/searchprofile.png',
        'bookTitle': 'Pride and Prejudice',
        'date': 'Joined: 22 june, 2026',
        'active': true,
      },
    ];

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
            searchWidget(),
        
            SizedBox(height: 0.5.h),
            Obx(() {
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
                      final active = author['active'] as bool? ?? false;
                      return WidgetSelectAuthor(
                        imagePath: author['imagePath'] as String,
                        bookTitle: author['name'] as String,
                        date: author['date'] as String,
                        activity: active ? 'Active' : 'Inactive',
                        isActive: active,
                        ontap: () {

                          Get.toNamed("/request" , arguments: {'role': 'selectAuthor'} );


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
