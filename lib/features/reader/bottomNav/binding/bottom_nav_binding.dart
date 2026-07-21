import 'package:get/get.dart';
import 'package:storysign/features/reader/profile/controller/profile_screen_controller.dart';

import '../../Home/controller/home_controller.dart';
import '../../Home/controller/track_request_controller.dart';
import '../../library/controller/library_controller.dart';
import '../../search/controller/search_page_controller.dart';
import '../controller/bottom_nav_controller.dart';


class BottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(()=> BottomNavController());

    Get.lazyPut<HomeController>(()=> HomeController());
    Get.lazyPut<TrackRequestController>(()=> TrackRequestController());

    Get.lazyPut<ReaderController>(()=> ReaderController());

    Get.lazyPut<SearchPageController>(()=> SearchPageController());
    Get.lazyPut<ProfileScreenController>(()=> ProfileScreenController());
  }
}

