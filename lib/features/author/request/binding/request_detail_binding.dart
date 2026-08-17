import 'package:get/get.dart';

import '../controller/request_detail_controller.dart';

class AuthorRequestDetailBinding implements Bindings {
  @override
  void dependencies() {

    if (Get.isRegistered<RequestDetailController>()) {
      Get.delete<RequestDetailController>(force: true);
    }
    Get.lazyPut<RequestDetailController>(() => RequestDetailController());

    // Get.put<RequestDetailController>(RequestDetailController());
  }
}
