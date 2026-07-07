import 'package:get/get.dart';
class RequestDetailController extends GetxController{

  // .obs variable
  var sourceScreen = ''.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      sourceScreen.value = Get.arguments['from'] ?? '';
      print("SOURCE SCREEN IS: ${sourceScreen.value}");
    }
  }

  // Getter mein .value lagayein
  bool get isFromDelivered => sourceScreen.value == 'all_delivered';
}