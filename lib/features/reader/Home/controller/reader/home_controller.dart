import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString selectedTab = "All".obs;

  RxBool isActive = true.obs;




  void selectTab(String tab) {
    selectedTab.value = tab;
  }
}
