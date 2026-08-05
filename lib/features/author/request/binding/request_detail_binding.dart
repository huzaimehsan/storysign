import 'package:get/get.dart';

import '../controller/request_detail_controller.dart';

class AuthorRequestDetailBinding implements Bindings {
  @override
  void dependencies() {
    // Force delete any existing instance (e.g. from the Request tab)
    // so we always start fresh with clean state when navigating from
    // either the Request tab or the Delivered tab.
    if (Get.isRegistered<RequestDetailController>()) {
      Get.delete<RequestDetailController>(force: true);
    }

    Get.put<RequestDetailController>(RequestDetailController());
  }
}
