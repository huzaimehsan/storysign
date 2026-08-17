import 'package:get/get.dart';
import 'package:storysign/features/author/notification/controller/author_notification_controller.dart'; // sahi wala import
import 'package:storysign/features/shared/notification/controller/notification_screen_controller.dart'; // apna path check karein

class AuthorNotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationScreenController>(
      () => AuthorNotificationController(),
      tag: 'author',
    );
  }
}
