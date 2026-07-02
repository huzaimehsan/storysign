import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';

import '../../../../widgets/customText_widget.dart';
import '../../widgets/subscription_header_widget.dart';
import '../../widgets/subscription_plan_card.dart';
import '../controller/subscription_plan_controller.dart';

class SubscriptionPlan extends GetView<SubscriptionPlanController> {
  const SubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
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
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonWidget(
                    'Monthly',
                    controller.isYearly.value ? whiteColor : buttonColor,
                    onTap: () => controller.setYearly(false),
                    colors: controller.isYearly.value ? buttonColor : whiteColor,

                    fontFamily: 'Poppins',
                    height: 3.5.h,
                    width: 24.w,
                    fontsize: 14.sp,
                    fontweight: FontWeight.w500,
                  ),
                  SizedBox(width: 5.w),
                  buttonWidget(
                    'Yearly',
                    controller.isYearly.value ? buttonColor : whiteColor,
                    onTap: () => controller.setYearly(true),
                    colors: controller.isYearly.value ? whiteColor : buttonColor,

                    fontFamily: 'Poppins',
                    height: 3.5.h,
                    width: 24.w,
                    fontsize: 14.sp,
                    fontweight: FontWeight.w500,
                  ),



                ],
              ),
            ),

            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.only(top: 2.h, bottom: 4.h),
                  itemCount: controller.plans.length,
                  itemBuilder: (context, index) {
                    final plan = controller.plans[index];
                    return SubscriptionPlanCard(
                      title: plan['title'] as String,
                      subtitle: plan['subtitle'] as String,
                      price: plan['price'] as String,
                      features:
                          List<String>.from(plan['features'] as List<dynamic>),
                      isMostPopular: plan['isMostPopular'] as bool,
                      onSelect: () {},
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
