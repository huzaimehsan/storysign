import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../widgets/subscription_plan_card.dart';
import '../controller/subscription_plan_controller.dart';
import '../../widgets/author_payment_section.dart';

class SubscriptionPlanSelectionScreen
    extends GetView<SubscriptionPlanController> {
  const SubscriptionPlanSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPlan = controller.selectedPlan.value;

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
              Expanded(
                child: selectedPlan == null
                    ? Center(
                        child: customText(
                          text: 'No plan selected',
                          fontFamily: 'Poppins',
                          color: primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubscriptionPlanCard(
                              title: selectedPlan['title'] as String,
                              subtitle: selectedPlan['subtitle'] as String,
                              price: selectedPlan['price'] as String,
                              features: List<String>.from(
                                selectedPlan['features'] as List<dynamic>,
                              ),
                              isMostPopular:
                                  selectedPlan['isMostPopular'] as bool,
                              onSelect: () {},
                              showActionButton: false,
                              showAmountRow: true,
                              amountLabel: 'Total Amount',
                              amountValue: selectedPlan['price'] as String,
                            ),
                            SizedBox(height: 2.h),
                             AuthorPaymentSection(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
