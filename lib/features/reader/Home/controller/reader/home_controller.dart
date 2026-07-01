import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString selectedTab = "All".obs;

  RxInt selectedAuthorIndex = 0.obs;

  void selectAuthor(int index) {
    selectedAuthorIndex.value = index;
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }
}