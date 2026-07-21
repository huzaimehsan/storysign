import 'package:get/get.dart';
import '../controller/subscription_plan_controller.dart';

class SubscriptionPlanBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionPlanController>(() => SubscriptionPlanController());
  }
}
