import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storysign/constants/local_db_key.dart';


class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateNext();
      }
    });
  }

  Future<void> _navigateNext() async {
    final prefs = Get.find<SharedPreferences>();

    await prefs.setBool('has_seen_splash', true);

    final hasSeenOnboarding = prefs.getBool(LocalDBKeys.ONBOARDING) ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');
    final isSubscribed = prefs.getBool(LocalDBKeys.IS_SUBSCRIBED) ?? false;

    String nextRoute;

    if (!hasSeenOnboarding) {
      nextRoute = '/onboarding';
    } else if (isLoggedIn) {
      if (role == 'author') {
        nextRoute = isSubscribed ? '/authorbottomnav' : '/plan';
      } else {
        nextRoute = '/bottomnav';
      }
    } else {
      nextRoute = '/signin';
    }

    Get.offAllNamed(nextRoute);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}