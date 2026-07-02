import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../search/widgets/header_widget.dart';
import '../controller/help_support_controller.dart';
import '../widget/help_support_widget.dart';
import '../widget/library_stat_card.dart';

class HelpAndSupport extends GetView<HelpAndSupportController> {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            customHeader(
              context: context,
              title: "Help & Support",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 2.h),
            searchWidget(
              onChanged: (val) {
                controller.searchQuery.value = val;
              },
            ),
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  libraryStatCardIcon(
                    title: 'Email',
                    imagePath: "assets/png/email.png",
                    value: '',
                    subtitle: '', ontap: () {  },
                  ),
                  libraryStatCardIcon(
                    title: 'Chat',
                    imagePath: "assets/png/chat.png",
                    value: '',
                    subtitle: '', ontap: () {
                      Get.toNamed("/contact");

                      
                  },
                  ),
                  libraryStatCardIcon(
                    title: 'call',
                    imagePath: "assets/png/call.png",
                    value: '',
                    subtitle: '', ontap: () {  },
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: customText(
                  text: "FAQS",
                  fontSize: 16.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Obx(() => ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredFaqs.length,
              itemBuilder: (context, index) {
                final faq = controller.filteredFaqs[index];
                return faqItemWidget(
                  title: faq['title']!,
                  description: faq['description']!,
                );
              },
            )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
