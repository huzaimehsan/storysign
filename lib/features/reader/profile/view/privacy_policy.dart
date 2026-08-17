import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../search/widgets/header_widget.dart';
import '../widget/help_support_widget.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final privayPolicyItems = [
      {
        'title': "Introduction",
        'description':
            "StorySign values your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, store, and protect user data within the StorySign platform.",
      },
      {
        'title': "Information We Collect",
        'description':
            "Readers: We may collect the following information:\n Full name\n Email address\n Profile information\n Payment-related information\n Uploaded ebooks and files\n Transaction history\n Communication and support requests",
      },
      {
        'title': "How We Use Your Information",
        'description':
            "Your information is used to:\n Create and manage accounts\n• Process payments and signature requests\n Deliver signed ebooks\n Improve platform functionality\n Provide customer support\n Manage subscriptions and transactions\n Ensure platform security and fraud prevention",
      },
      {
        'title': "Ebook & Content Usage",
        'description':
            "Uploaded ebooks are used only for processing signature requests and delivering signed copies to readers. StorySign does not claim ownership of uploaded content.",
      },
      {
        'title': "Payment Security",
        'description':
            "All payment transactions are processed through secure payment gateways. StorySign does not store sensitive payment card details directly on its servers.",
      },
      {
        'title': "Data Protection",
        'description':
            "We implement industry-standard security measures to protect user data against unauthorized access, loss, or misuse.",
      },
      {
        'title': "Sharing of Information",
        'description':
            "StorySign does not sell or rent personal information to third parties. Information may only be shared with trusted service providers required for payment processing or platform operations.",
      },
      {
        'title': "Contact Us",
        'description':
            "Readers can access their completed signed ebooks from their personal library within the app. For other inquiries, please contact our support team through the app.",
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            customHeader(
              context: context,
              title: "Privacy Policy",
              onBack: () => Get.back(),
              onIconPressed: () {},
            ),
            SizedBox(height: 1.h),

            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: privayPolicyItems.length,
                  itemBuilder: (context, index) {
                    final faq = privayPolicyItems[index];
                    return faqItemWidget(
                      title: faq['title']!,
                      description: faq['description']!,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
