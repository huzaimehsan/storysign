import 'package:get/get.dart';
import 'package:storysign/features/author/delivered/controller/delivered_controller.dart';
import 'package:storysign/features/author/request/controller/all_request_controller.dart';

import 'package:storysign/features/author/home/controller/home_controller.dart';

import 'package:storysign/features/author/profile/controller/profile_controller.dart';

import '../../../shared/notification/controller/notification_screen_controller.dart';
import '../../notification/controller/author_notification_controller.dart';
import '../controller/author_bottom_nav_controller.dart';

class AuthorBottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorBottomNavController>(() => AuthorBottomNavController());
    Get.lazyPut<AuthorHomeController>(() => AuthorHomeController(), fenix: true);
    Get.lazyPut<AllRequestController>(() => AllRequestController(), fenix: true);
    Get.lazyPut<DeliveredController>(() => DeliveredController(), fenix: true);

    Get.lazyPut<NotificationScreenController>(() => AuthorNotificationController(), tag: 'author', fenix: true);
    Get.lazyPut<AuthorProfileController>(() => AuthorProfileController(), fenix: true);
  }
}
