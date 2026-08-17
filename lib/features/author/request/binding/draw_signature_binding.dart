import 'package:get/get.dart';

import '../controller/draw_signature_controller.dart';


class DrawSignatureBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrawSignatureController>(() => DrawSignatureController());
  }
}

