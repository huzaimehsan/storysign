import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../search/widgets/header_widget.dart';
import '../widget/help_support_widget.dart';
import '../widget/library_stat_card.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final faqItems = [
      {
        'title': '1. What is StorySign?',
        'description': 'StorySign is a digital platform that allows readers to request personalized ebook signatures from authors through a secure and interactive experience.',
      },
      {
        'title': '2. How does StorySign work?',
        'description': 'Readers can browse author profiles, upload their ebooks, request signed ebook copies from authors, and receive digitally delivered signed copies.',
      },
      {
        'title': '3. Can readers upload their own ebooks?',
        'description': 'Yes. Readers can upload their ebooks in supported formats and request signatures from available authors.',
      },
      {
        'title': '4. Do authors need a subscription plan?',
        'description': 'Yes. Authors must subscribe to a plan before accessing author features and receiving signature requests.',
      },
      {
        'title': '5. What subscription plans are available for authors?',
        'description': 'Starter Plan – 25 signatures per month; Professional Plan – 100 signatures per month; Premium Plan – Unlimited signatures per month.',
      },
      {
        'title': '6. Can authors reject signature requests?',
        'description': 'Yes. Authors can either accept or reject requests based on availability or request details.',
      },
      {
        'title': '7. What payment methods are supported?',
        'description': 'StorySign supports secure online payment methods including debit cards, credit cards, and digital payment options.',
      },
      // ... baki items waise hi rahein
    ];

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
            searchWidget(),
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
                    subtitle: '',
                  ),
                  libraryStatCardIcon(
                    title: 'Chat',
                    imagePath: "assets/png/chat.png",
                    value: '',
                    subtitle: '',
                  ),
                  libraryStatCardIcon(
                    title: 'call',
                    imagePath: "assets/png/call.png",
                    value: '',
                    subtitle: '',
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: customText(
                  text: "FAQS",
                  fontSize: 16.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: whiteColor, // White ki jagah visible color rakha
                ),
              ),
            ),
            SizedBox(height : 1.h),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true, // Zaroori hai kyunki hum isay SingleChildScrollView ke andar use kar rahe hain
              physics: const NeverScrollableScrollPhysics(), // Scroll ko parent (SingleChildScrollView) ke hawale kar deta hai
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                final faq = faqItems[index];
                return faqItemWidget(
                  title: faq['title']!,
                  description: faq['description']!,
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
