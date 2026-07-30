import 'package:get/get.dart';
import 'package:storysign/features/reader/notification/controller/notification_controller.dart';
import 'package:storysign/features/shared/notification/controller/notification_screen_controller.dart'; // apna path check karein

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationScreenController>(
          () => NotificationController(),
      tag: 'reader',
    );
  }
}