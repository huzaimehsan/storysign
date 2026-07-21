import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/features/author/subscriptionplan/controller/stripe_payment_controller.dart';
import 'package:storysign/features/author/subscriptionplan/model/subscription_model.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/subscription_header_widget.dart';
import '../../widgets/subscription_plan_card.dart';
import '../controller/subscription_plan_controller.dart';


class SubscriptionPlanSelectionScreen
    extends GetView<SubscriptionPlanController> {
  const SubscriptionPlanSelectionScreen({super.key});

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
              Expanded(
                child: Obx(
                  () {
                    final selectedPlan = controller.selectedPlan.value;
                    final paymentController = Get.find<StripePaymentController>();
                    
                    if (selectedPlan == null) {
                      return Center(
                        child: customText(
                          text: 'No plan selected',
                          fontFamily: 'Poppins',
                          color: primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SubscriptionPlanCard(
                            title: selectedPlan.name,
                            subtitle: selectedPlan.planType,
                            price: selectedPlan.price.toString(),
                            features: selectedPlan.features,
                            isMostPopular: selectedPlan.name.toLowerCase().contains('pro'),
                            onSelect: () {},
                            showActionButton: false,
                            showAmountRow: true,
                            amountLabel: 'Total Amount',
                            amountValue: selectedPlan.price.toString(),
                          ),
                          SizedBox(height: 2.h),

                      Obx(() {
                      final isLoading = paymentController.isPaymentLoading.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),

                          buttonWidget(
                            isLoading ? 'Processing...' : 'Confirm Payment',
                            whiteColor,
                            onTap: isLoading
                                ? () {}
                                : () async {
                              final success = await paymentController.processPayment(selectedPlan.id);
                              if (success) {
                                Get.toNamed('/authorbottomnav');
                              }
                            },
                            fontFamily: 'Poppins',
                            height: 5.2.h,
                            width: double.infinity,
                            fontsize: 16.sp,
                            fontweight: FontWeight.w600,
                            colors: isLoading ? Colors.grey.shade600 : buttonColor,
                          ),
                        ],
                      );
                    }),
                        ],
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
