import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';

import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../home/controller/home_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../widgets/subscription_plan_card.dart';
import '../controller/subscription_plan_controller.dart';

class SubscriptionPlan extends GetView<SubscriptionPlanController> {
  const SubscriptionPlan({super.key});


  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String,dynamic>?;
    final fromSignUp = args?['from'] == 'signUp';
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              customHeaderAuthor(
                context: context,
                title: 'Subscription Plans',
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
              SizedBox(height: 2.h),
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buttonWidget(
                        'Monthly',
                        controller.isYearly.value ? buttonColor : whiteColor,
                        onTap: () => controller.setYearly(false),
                        colors: controller.isYearly.value
                            ? whiteColor
                            : buttonColor,
                        fontFamily: 'Poppins',
                        height: 3.5.h,
                        width: 24.w,
                        fontsize: 14.sp,
                        fontweight: FontWeight.w500,
                      ),
                      SizedBox(width: 5.w),
                      buttonWidget(
                        'Yearly',
                        controller.isYearly.value ? whiteColor : buttonColor,
                        onTap: () => controller.setYearly(true),
                        colors: controller.isYearly.value
                            ? buttonColor
                            : whiteColor,
                        fontFamily: 'Poppins',
                        height: 3.5.h,
                        width: 24.w,
                        fontsize: 14.sp,
                        fontweight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: Obx(
                  () {
                    // Resolve the active plan from live controllers (always fresh after payment).
                    // Falls back to stale args only when controllers haven't loaded yet (e.g. first sign-up).
                    String? activePlanId;
                    String? activePlanName;

                    if (Get.isRegistered<AuthorHomeController>()) {
                      final activeSub = Get.find<AuthorHomeController>()
                          .activeSub
                          .value;
                      activePlanId = activeSub?.planId;
                      activePlanName = activeSub?.planName;
                    }
                    if ((activePlanId == null || activePlanId.isEmpty) &&
                        Get.isRegistered<AuthorProfileController>()) {
                      final profile = Get.find<AuthorProfileController>()
                          .authorProfile
                          .value;
                      activePlanId = profile?.activePlanId;
                      if (activePlanName == null || activePlanName.isEmpty) {
                        activePlanName = profile?.activePlanName;
                      }
                    }
                    // Last resort: use args (only present before controllers load)
                    final Map<String, dynamic>? navArgs = Get.arguments;
                    if (activePlanId == null || activePlanId.isEmpty) {
                      activePlanId = navArgs?['planId']?.toString();
                    }
                    if (activePlanName == null || activePlanName.isEmpty) {
                      activePlanName = navArgs?['planName']?.toString();
                    }

                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: buttonColor),
                      );
                    }

                    if (controller.plans.isEmpty) {
                      return Center(
                        child: customText(
                          text: 'No subscription plans available',
                          color: greyColor,
                          fontSize: 15.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      backgroundColor: containerColor,
                      color: white,
                      onRefresh: () => controller.fetchSubscriptionPlans(
                        controller.isYearly.value ? 'yearly' : 'monthly',
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.plans.length,
                        itemBuilder: (context, index) {
                          final plan = controller.plans[index];

                          final bool isCurrentPlan = (activePlanId != null &&
                              activePlanId.isNotEmpty &&
                              plan.id.trim().toLowerCase() ==
                                  activePlanId.trim().toLowerCase()) ||
                          (activePlanName != null &&
                              activePlanName.isNotEmpty &&
                              plan.name.trim().toLowerCase() ==
                                  activePlanName.trim().toLowerCase());

                          String getButtonText() {
                            if (isCurrentPlan) return 'Current Plan';
                            if (activePlanName == null ||
                                activePlanName.isEmpty ||
                                fromSignUp) return 'Select Plan';
                            return 'Upgrade to ${plan.name}';
                          }

                          return SubscriptionPlanCard(
                            title: plan.name,
                            subtitle: plan.planType,
                            price: plan.price.toString(),
                            features: plan.features,
                            isMostPopular:
                                plan.name.toLowerCase().contains('pro'),
                            onSelect: () => controller.selectPlan(plan),
                            isCurrentPlan: isCurrentPlan,
                            buttonText: getButtonText(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

