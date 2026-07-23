import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {

    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? role = prefs.getString('role');

    if (isLoggedIn) {

      if (role == 'author') {
        Get.offAllNamed('/authorbottomnav');
      } else {
        Get.offAllNamed('/bottomnav');
      }
    } else {
      // Agar login nahi hai, toh kuch na karein (User Splash Screen par hi rahega)
    }
  }
}