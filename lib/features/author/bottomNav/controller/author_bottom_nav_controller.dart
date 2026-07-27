import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/notification/controller/author_notification_controller.dart';
import 'package:storysign/features/author/delivered/controller/delivered_controller.dart';
import 'package:storysign/features/author/profile/controller/profile_controller.dart';

import '../../../shared/notification/notification_screen_controller.dart';

import '../../home/controller/home_controller.dart';

// Apne baki controllers ke path yahan import karein
// import '../../author/search/controller/search_controller.dart';
// import '../../author/profile/controller/profile_controller.dart';

class AuthorBottomNavController extends GetxController {
  var currentIndex = 0.obs;

  /// Author side ke tabs ke liye Navigator keys
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;

    // Index 0: Home Tab
    if (index == 0) {
      try {
        if (Get.isRegistered<AuthorHomeController>()) {
          Get.find<AuthorHomeController>().fetchLibraryStats();
          Get.find<AuthorHomeController>().fetchAutographRequests();
          Get.find<AuthorHomeController>().fetchSubscriptionPlan();
          Get.find<AuthorHomeController>().loadAuthorProfile();
        }
      } catch (e) {
        debugPrint("Error refreshing Home tab: $e");
      }
    }

    // Index 1: Request Tab (AllRequest screen uses AuthorHomeController)
    if (index == 1) {
      try {
        if (Get.isRegistered<AuthorHomeController>()) {
          Get.find<AuthorHomeController>().fetchAutographRequests();
        }
      } catch (e) {
        debugPrint("Error refreshing Request tab: $e");
      }
    }

    // Index 2: Delivered Tab
    if (index == 2) {
      try {
        if (Get.isRegistered<DeliveredController>()) {
          // DeliveredController uses static data for now,
          // add fetch call here when API is integrated
        }
      } catch (e) {
        debugPrint("Error refreshing Delivered tab: $e");
      }
    }

    // Index 3: Notification Tab
    if (index == 3) {
      try {
        if (Get.isRegistered<NotificationScreenController>(tag: 'author')) {
          final ctrl = Get.find<NotificationScreenController>(tag: 'author');
          if (ctrl is AuthorNotificationController) {
            ctrl.getNotifications();
          }
        }
      } catch (e) {
        debugPrint("Error refreshing Notification tab: $e");
      }
    }

    // Index 4: Profile Tab
    if (index == 4) {
      try {
        if (Get.isRegistered<AuthorProfileController>()) {
          Get.find<AuthorProfileController>().getProfile();
        }
      } catch (e) {
        debugPrint("Error refreshing Profile tab: $e");
      }
    }
  }

  /// Current tab mein push karne ke liye
  void pushInTab(int tabIndex, String routeName, {Object? arguments}) {
    navigatorKeys[tabIndex].currentState?.pushNamed(routeName, arguments: arguments);
  }

  /// Current tab mein pop karne ke liye
  void popCurrentTab() {
    final nav = navigatorKeys[currentIndex.value].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }
}