import 'package:get/get.dart';
import 'package:storysign/features/shared/auth/controller/splash_controller.dart';

import '../controller/auth_controller.dart';


class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(()=> AuthController());
    Get.lazyPut<SplashController>(()=> SplashController());
  }
}

