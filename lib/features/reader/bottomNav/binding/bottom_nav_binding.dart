import 'package:get/get.dart';
import 'package:storysign/features/reader/profile/controller/help_support_controller.dart';

import '../../Home/controller/home_controller.dart';
import '../../library/controller/library_controller.dart';
import '../../search/controller/search_page_controller.dart';
import '../controller/bottom_nav_controller.dart';


class BottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(()=> BottomNavController());

    Get.lazyPut<HomeController>(()=> HomeController());

    Get.lazyPut<ReaderController>(()=> ReaderController());

    Get.lazyPut<SearchPageController>(()=> SearchPageController());
    Get.lazyPut<HelpAndSupportController>(()=> HelpAndSupportController());
  }
}

