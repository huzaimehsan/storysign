import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';
import 'package:storysign/features/reader/Home/controller/track_request_controller.dart';

import '../../../shared/notification/controller/notification_screen_controller.dart';
import '../../library/controller/library_controller.dart';
import '../../notification/controller/notification_controller.dart';
import '../../profile/controller/profile_screen_controller.dart';
import '../../search/controller/search_page_controller.dart';

class BottomNavController extends GetxController{

  var currentIndex = 0.obs;
  final Map<int, int> tabSources = {0: 0};

  /// Navigator keys for each tab — used by nested navigators in BottomNavLayout
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void setTabSource(int tabIndex, int sourceIndex) {
    if (tabIndex < 0 || tabIndex >= navigatorKeys.length) return;
    if (sourceIndex < 0 || sourceIndex >= navigatorKeys.length) return;
    tabSources[tabIndex] = sourceIndex;
  }

  void changeIndex(int index) {
    if (index < 0 || index >= navigatorKeys.length) return;
    currentIndex.value = index;

    if (index == 0) {
      try {
        // 1. Home Controller check
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchHomeData();
          Get.find<HomeController>(). fetchMyBooks();

        }
   
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
      try {
        if (Get.isRegistered<ReaderController>()) {
          Get.find<ReaderController>().refreshRequests();
        }
      } catch (_) {}
    }


    if (index == 3) {
      try {
        if (Get.isRegistered<NotificationScreenController>(tag: 'reader')) {
          final ctrl = Get.find<NotificationScreenController>(tag: 'reader');
          if (ctrl is NotificationController) {
            ctrl.getNotifications();
          }
        }
      } catch (e) {
        debugPrint("Error refreshing Notification tab: $e");
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

  /// Pop the top route in the current active tab.
  /// If the current tab is already at its root screen, go back to Home (index 0).
  void popCurrentTabOrGoToPrevious() {
    final nav = navigatorKeys[currentIndex.value].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return;
    }

    if (currentIndex.value != 0) {
      changeIndex(0);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Ensure notification controller is registered early so tab switches can trigger fetches
    try {
      if (!Get.isRegistered<NotificationController>(tag: 'reader')) {
        Get.lazyPut<NotificationController>(() => NotificationController(), tag: 'reader');
      }
    } catch (_) {}

  }
}
