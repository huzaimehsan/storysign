import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/splash_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(()=> AuthController());
    Get.lazyPut<SplashController>(()=> SplashController());
  }
}

