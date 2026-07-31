import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../../author/profile/controller/help_and_support_controller.dart';
import '../../search/widgets/header_widget.dart';
import '../controller/help_support_controller.dart';
import '../widget/help_support_widget.dart';
import '../widget/library_stat_card.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        (ModalRoute.of(context)?.settings.arguments ?? Get.arguments)
            as Map<String, dynamic>?;
    final String role = args?['role']?.toString() ?? 'reader';

    final dynamic controller = role == 'author'
        ? Get.find<AuthorHelpSupportController>()
        : Get.find<HelpSupportController>();

    return Scaffold(
      body: RefreshIndicator(
        color: buttonColor,
        onRefresh: () => controller.refreshHelpSupport(),
        child: SafeArea(
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
                child: Obx(() {
                  // 3. Role ke mutabiq sahi support data variable uthayein
                  final data = role == 'author'
                      ? controller.supportAuthorData.value
                      : controller.supportData.value;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. EMAIL BUTTON
                      libraryStatCardIcon(
                        title: 'Email',
                        imagePath: "assets/png/email.png",
                        value: '',
                        subtitle: '',
                        ontap: () async {
                          if (data != null && data.email.isNotEmpty) {
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: data.email,
                            );
                            try {
                              await launchUrl(emailUri);
                            } catch (e) {
                              Utils.showToast("Could not open email app", true);
                            }
                          } else {
                            Utils.showToast("Email not available", true);
                          }
                        },
                      ),

                      // 2. CALL BUTTON

                      // 3. CHAT BUTTON
                      libraryStatCardIcon(
                        title: 'Chat',
                        imagePath: "assets/png/chat.png",
                        value: '',
                        subtitle: '',
                        ontap: () async {
                          print(role);
                          if (data != null && data.supportUrl.isNotEmpty) {
                            final Uri url = Uri.parse(data.supportUrl);
                            try {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              Utils.showToast("Could not open chat link", true);
                            }
                          } else {
                            Get.toNamed("/contact", arguments: {'role': role});
                          }
                        },
                      ),
                      libraryStatCardIcon(
                        title: 'Call',
                        imagePath: "assets/png/call.png",
                        value: '',
                        subtitle: '',
                        ontap: () async {
                          print(role);
                          if (data != null && data.phone.isNotEmpty) {
                            final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: data.phone,
                            );
                            try {
                              await launchUrl(
                                phoneUri,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              Utils.showToast("Could not open phone dialer", true);
                            }
                          } else {
                            Utils.showToast("Phone number not available", true);
                          }
                        },
                      ),

                    ],
                  );
                }),
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
              Obx(() {
                final faqs = role == 'author'
                    ? controller.faqAuthorList
                    : controller.faqList;

                return Expanded(
                  child: controller.isFaqsLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(color: buttonColor),
                        )
                      : faqs.isEmpty
                      ? Center(
                          child: customText(
                            text: "No FAQS",
                            fontSize: 16.sp,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: greyColor,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: faqs.length,
                          itemBuilder: (context, index) {
                            final faq = faqs[index];
                            return faqItemWidget(
                              title: faq.question,
                              description: faq.answer,
                            );
                          },
                        ),
                );
              }),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
