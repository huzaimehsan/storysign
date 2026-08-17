import 'package:get/get.dart';

import 'package:storysign/features/reader/Home/controller/request_autograph_controller.dart';

class RequestAutographBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestAutographController>(() => RequestAutographController());
  }
}
