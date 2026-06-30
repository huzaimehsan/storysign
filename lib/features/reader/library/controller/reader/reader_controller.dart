import 'package:get/get.dart';

class ReaderController extends GetxController {
  RxString selectedTab = "All".obs;

  void selectTab(String tab) {
    selectedTab.value = tab;
  }
}
