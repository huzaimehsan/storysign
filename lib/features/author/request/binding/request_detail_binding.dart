import 'package:get/get.dart';

import '../controller/request_detail_controller.dart';

class AuthorRequestDetailBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut<RequestDetailController>(() => RequestDetailController());
  }
}
