import 'package:get/get.dart';
import 'package:storysign/features/reader/profile/controller/profile_screen_controller.dart';

import '../../../shared/notification/controller/notification_screen_controller.dart';
import '../../Home/controller/home_controller.dart';
import '../../Home/controller/track_request_controller.dart';
import '../../library/controller/library_controller.dart';
import '../../notification/controller/notification_controller.dart';
import '../../search/controller/search_page_controller.dart';
import '../controller/bottom_nav_controller.dart';


class BottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(()=> BottomNavController());

    Get.lazyPut<HomeController>(()=> HomeController(), fenix: true);

    Get.lazyPut<ReaderController>(()=> ReaderController(), fenix: true);

    Get.lazyPut<SearchPageController>(()=> SearchPageController(), fenix: true);
    Get.lazyPut<ProfileScreenController>(()=> ProfileScreenController(), fenix: true);
    Get.lazyPut<NotificationScreenController>(() => NotificationController(), tag: 'reader', fenix: true);
  }
}

