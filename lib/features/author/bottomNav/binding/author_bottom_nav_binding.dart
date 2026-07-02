import 'package:get/get.dart';

import '../controller/author_bottom_nav_controller.dart';
import '../../subscriptionplan/controller/subscription_plan_controller.dart';

class AuthorBottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorBottomNavController>(() => AuthorBottomNavController());
    Get.lazyPut<SubscriptionPlanController>(() => SubscriptionPlanController());
  }
}
