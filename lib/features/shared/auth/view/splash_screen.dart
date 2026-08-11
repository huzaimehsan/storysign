import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/constants/color_constants.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: containerColor,
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, _) {
            return Opacity(
              opacity: controller.fadeAnimation.value,
              child: Transform.scale(
                scale: controller.scaleAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icon/logo.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                  
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
