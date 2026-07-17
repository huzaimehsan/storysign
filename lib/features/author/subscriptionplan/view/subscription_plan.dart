import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';

import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../widgets/subscription_plan_card.dart';
import '../controller/subscription_plan_controller.dart';

class SubscriptionPlan extends GetView<SubscriptionPlanController> {
  const SubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context) {

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
                  padding:  EdgeInsets.only(bottom: 1.h),
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

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.plans.length,
                      itemBuilder: (context, index) {
                        final plan = controller.plans[index];
                        return SubscriptionPlanCard(
                          title: plan.name,
                          subtitle: plan.planType,
                          price: plan.price.toString(),
                          features: plan.features,
                          isMostPopular: plan.name.toLowerCase().contains('pro'),
                          onSelect: () => controller.selectPlan(plan),
                        );
                      },
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
