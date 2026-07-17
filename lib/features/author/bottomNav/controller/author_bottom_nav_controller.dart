import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  ];

  void changeIndex(int index) {
    currentIndex.value = index;

    // Index 0: Home Tab
    if (index == 0) {
      if (Get.isRegistered<AuthorHomeController>()) {
        Get.find<AuthorHomeController>().fetchLibraryStats(); // Stats ya Home ka data
      // Pending requests
      }
    }

    // Index 1: Search/Other Tab (Aapke project ke hisaab se)
    // if (index == 1) { ... }

    // Index 3: Profile Tab
    if (index == 3) {
      // if (Get.isRegistered<AuthorProfileController>()) {
      //   Get.find<AuthorProfileController>().getProfile();
      // }
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