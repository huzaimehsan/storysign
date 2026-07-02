import 'dart:async';

import 'package:get/get.dart';

class AuthController extends GetxController {
  RxInt remainingSeconds = 60.obs;
  RxBool isTimerRunning = false.obs;
  Timer? _timer;

  var selectedRole = 'Reader'.obs;
  RxBool isSelected = false.obs;

  void startTimer() {
    isTimerRunning.value = true;
    remainingSeconds.value = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        isTimerRunning.value = false;
        timer.cancel();
      }
    });
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void proceed() {
    print("User selected: ${selectedRole.value}");

    if (selectedRole.value == "Reader") {
      Get.toNamed('/signup');
    } else {
      Get.toNamed('/signup');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
