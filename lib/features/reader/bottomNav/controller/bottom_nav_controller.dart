import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';
import 'package:storysign/features/reader/Home/controller/track_request_controller.dart';
import 'package:storysign/features/reader/profile/controller/profile_controller.dart';
import '../../library/controller/library_controller.dart';
import '../../profile/controller/profile_screen_controller.dart';
import '../../search/controller/search_page_controller.dart';

class BottomNavController extends GetxController{

  var currentIndex = 0.obs;

  /// Navigator keys for each tab — used by nested navigators in BottomNavLayout
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;

    if (index == 0) {
      try {
        // 1. Home Controller check
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchHomeData();
          Get.find<HomeController>(). fetchMyBooks(loadMore: true);

        }
        // 2. Sahi tarika 'else if' ka use karna hai
        else if (Get.isRegistered<TrackRequestController>()) {
          Get.find<TrackRequestController>().fetchTrackRequestData();
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
    if (index == 1) {
      try {
        if (Get.isRegistered<SearchPageController>()) {
          Get.find<SearchPageController>().fetchHomeData();

        }
      } catch (_) {}
    }


    if (index == 2) {
      if (Get.isRegistered<ReaderController>()) {
        Get.find<ReaderController>().fetchBooksData();
      }
    }


    if (index == 4) {
      if (Get.isRegistered<ProfileScreenController>()) {
        Get.find<ProfileScreenController>().getProfile();
      }
    }
  }

  /// Push a route within the Search tab (tab index 1) keeping bottom nav visible
  void pushInSearchTab(String routeName, {Object? arguments}) {
    navigatorKeys[1].currentState?.pushNamed(routeName, arguments: arguments);
  }

  /// Pop the top route in the current active tab
  void popCurrentTab() {
    final nav = navigatorKeys[currentIndex.value].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }
}
