import 'package:get/get.dart';
import 'package:storysign/features/author/subscriptionplan/controller/stripe_payment_controller.dart';
import '../controller/subscription_plan_controller.dart';

class SubscriptionPlanBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionPlanController>(() => SubscriptionPlanController());
    Get.lazyPut<StripePaymentController>(() => StripePaymentController());
  }
}
